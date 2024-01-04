import 'dart:async';

import 'package:eduflex/components/auth.dart';
import 'package:eduflex/components/drawer.dart';
import 'package:eduflex/pages/chatHome.dart';
import 'package:eduflex/pages/friends.dart';
import 'package:eduflex/provider.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  // List<dynamic> _startedChat = [];
  late StreamController<List<dynamic>> _streamController;
  late Stream<List<dynamic>> _stream;
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    getFriend();
  }

  void getFriend() async {
    // List<dynamic> startedChat = await MyProvider.getStartedChat();
    // setState(() {
    //   _startedChat = startedChat;
    // });
    _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      try {
        List<dynamic> startedChat = await MyProvider.getStartedChat();
        _streamController.add(startedChat);
      } catch (e) {
        print('Error: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Chat Room "),
        centerTitle: true,
        actions: [profilepic(context)],
      ),
      drawer: MyDrawer(),
      body: Container(
        child: Column(
          children: [
            StreamBuilder(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final _startedChat = snapshot.data;
                    return Expanded(
                      child: ListView.builder(
                          itemCount: _startedChat!.length == 0
                              ? 1
                              : _startedChat!.length,
                          itemBuilder: (context, i) {
                            if (_startedChat!.length != 0) {
                              Map<String, dynamic> data =
                                  _startedChat[i] as Map<String, dynamic>;
                              DateTime dateTime =
                                  DateTime.parse(data['msg']['created']);
                              String amPm = (dateTime.hour < 12) ? 'AM' : 'PM';
                              String time =
                                  '${dateTime.hour}:${dateTime.minute} $amPm';
                              return GestureDetector(
                                onTap: () async {
                                  _timer.cancel();

                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                                data: data,
                                                roomid: data['msg']['roomid'],
                                              )));
                                  print("back from chat baby");
                                  setState(() {
                                    _timer = Timer.periodic(
                                        Duration(seconds: 2), (timer) async {
                                      try {
                                        List<dynamic> startedChat =
                                            await MyProvider.getStartedChat();
                                        _streamController.add(startedChat);
                                      } catch (e) {
                                        print('Error: $e');
                                      }
                                    });
                                  });
                                },
                                child: Stack(children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 10),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border(
                                            bottom: BorderSide(
                                          color: Theme.of(context).cardColor,
                                        ))),
                                    child: Row(
                                      children: [
                                        userProfilepPic(
                                            context,
                                            data['user']['avatar'],
                                            data['user']['name'],
                                            data['user']['isOnline']),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${data['user']['name']}',
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              '${data['msg']['body']}',
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.5)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      top: 20,
                                      right: 20,
                                      child: Text(
                                        time,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .primaryColorDark),
                                      )),
                                ]),
                              );
                            } else {
                              return Text("you have no chat");
                            }
                          }),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  }
                })
          ],
        ),
      ),
      floatingActionButton: IconButton(
          onPressed: () {
            _timer.cancel();
            _streamController.close();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Friends()));
          },
          icon: Icon(Icons.person)),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _streamController.close();
    super.dispose();
  }
}
