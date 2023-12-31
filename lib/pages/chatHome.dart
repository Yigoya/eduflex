import 'package:eduflex/provider.dart';
import 'package:eduflex/service/schema/user.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
  const ChatScreen({super.key, required this.data, this.isNew = false});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<dynamic> _message = [];
  String? _roomid;
  User? _user;
  final TextEditingController _controller = TextEditingController();
  WebSocketChannel channel =
      IOWebSocketChannel.connect('ws://192.168.12.1:8000/ws/server/w');
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    print(widget.data);
    getMessage();
    // Listen for incoming messages from the server asynchronously

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
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
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
    _scrollToBottom();
  }

  void getMessage() async {
    User? user = await MyProvider.user();
    if (widget.isNew) {
      String roomid = await MyProvider.setStartChat(widget.data['id']);
      print(roomid);
      List<dynamic> message = await MyProvider.getMessage(roomid);
      print(message);
      setState(() {
        channel = IOWebSocketChannel.connect(
            'ws://192.168.12.1:8000/ws/server/${widget.data['msg']['roomid']}');
        _roomid = roomid;
        _message = message;
        _user = user;
      });
    } else {
      List<dynamic> message =
          await MyProvider.getMessage(widget.data['msg']['roomid']);
      setState(() {
        channel = IOWebSocketChannel.connect(
            'ws://192.168.12.1:8000/ws/server/${widget.data['msg']['roomid']}');
        _roomid = widget.data['msg']['roomid'];
        _message = message;
        _user = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('WebSocket Chat'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  height: MediaQuery.of(context).size.height - 150,
                  child: ListView.builder(
                    dragStartBehavior: DragStartBehavior.down,
                    controller: _scrollController,
                    itemCount: _message.length == 0 ? 1 : _message.length,
                    itemBuilder: (context, i) {
                      if (_message.length == 0) {
                        return Text('start chat');
                      }
                      _scrollToBottom();
                      bool isUser = _message[i]['sender'] == _user!.id;
                      return Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: isUser
                                  ? Radius.circular(10)
                                  : Radius.circular(0),
                              bottomRight: isUser
                                  ? Radius.circular(0)
                                  : Radius.circular(10),
                            ),
                            border: Border.all(
                                color: isUser ? Colors.blue : Colors.brown)),
                        child: Text('${_message[i]['body']}'),
                      );
                    },
                  )),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Enter your message...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      final message = _controller.text;
                      if (message.isNotEmpty) {
                        Map<String, dynamic> data = {
                          'body': message,
                          'sender': _user!.id,
                          'receiver': widget.data['id'],
                          'roomid': _roomid
                        };
                        print(data);
                        // context.read<ChatBloc>().addMessage(data['body']);
                        channel.sink.add(jsonEncode(data));
                        _controller.clear();
                        _scrollToBottom();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
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
