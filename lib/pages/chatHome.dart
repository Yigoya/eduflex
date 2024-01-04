import 'package:eduflex/components/auth.dart';
import 'package:eduflex/components/chatMessage.dart';
import 'package:eduflex/provider.dart';
import 'package:eduflex/service/schema/user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'WebSocket Chat',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: BlocProvider(
//         create: (context) => ChatBloc(),
//         child: ChatScreen(),
//       ),
//     );
//   }
// }

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isNew;
  final String roomid;
  const ChatScreen(
      {super.key,
      required this.data,
      this.isNew = false,
      required this.roomid});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _userScrolling = false;
  List<dynamic> _message = [];
  User? _user;
  final TextEditingController _controller = TextEditingController();
  late WebSocketChannel channel = IOWebSocketChannel.connect(
      '${MyProvider.wsserver}/ws/server/${widget.roomid}');
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    print(widget.data);
    getMessage();
    // Listen for incoming messages from the server asynchronously
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });

    // _scrollController.addListener(() {
    //   if (_scrollController.position.userScrollDirection ==
    //       ScrollDirection.forward) {
    //     // User is scrolling up
    //     _userScrolling = true;
    //   } else {
    //     // User is scrolling down or at the bottom
    //     _userScrolling = false;
    //   }
    // });

    channel.stream.listen(
      (message) async {
        await processMessage(message);
      },
      onDone: () {
        print('WebSocket channel closed');
      },
      onError: (error) {
        print('Error in WebSocket: $error');
      },
    );
  }

  // Simulate an asynchronous message processing function
  Future<void> processMessage(String message) async {
    Map<String, dynamic> value = jsonDecode(message);
    // Simulate processing time
    // await Future.delayed(Duration(seconds: 1));
    // Add the message to the Bloc to update the UI
    if (value['type'] == 'chat') {
      setState(() {
        _message.add(value['msg']);
      });
    }
    // if (!_userScrolling) {
    //   // Scroll to bottom only if the user is not currently scrolling
    //   _scrollToBottom();
    // }
  }

  void getMessage() async {
    User? user = await MyProvider.user();

    List<dynamic> message = await MyProvider.getMessage(widget.roomid);
    setState(() {
      _message = message;
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Row(
          children: [
            userProfilepPic(
              context,
              widget.isNew
                  ? widget.data['avatar']
                  : widget.data['user']['avatar'],
              widget.isNew ? widget.data['name'] : widget.data['user']['name'],
              widget.isNew
                  ? widget.data['isOnline']
                  : widget.data['user']['isOnline'],
            ),
            Text(widget.isNew
                ? widget.data['name']
                : widget.data['user']['name'])
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _message.length == 0 ? 1 : _message.length,
              itemBuilder: (context, i) {
                if (_message.length == 0) {
                  return Center(child: Text('Start chat'));
                }
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                });
                bool isUser = _message[i]['sender'] == _user!.id;
                Map<String, dynamic> data = _message[i] as Map<String, dynamic>;
                return Message(data: data, isUser: isUser);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration:
                BoxDecoration(color: Theme.of(context).primaryColorLight),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      // if (_controller.text == '') {
                      setState(() {});
                      // }
                    },
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: 'Enter your message...',
                        border: InputBorder.none),
                  ),
                ),
                (_controller.text != '')
                    ? IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          final message = _controller.text;
                          if (message.isNotEmpty) {
                            Map<String, dynamic> data = {
                              'body': message,
                              'sender': _user!.id,
                              'receiver': widget.isNew
                                  ? widget.data['id']
                                  : widget.data['user']['id'],
                              'roomid': widget.roomid
                            };
                            print(data);
                            channel.sink.add(jsonEncode(data));
                            _controller.clear();
                            _scrollToBottom();
                          }
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.attach_file),
                        onPressed: () {
                          _scrollToBottom();
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 70,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
