import 'dart:async';

import 'package:eduflex/components/auth.dart';
import 'package:eduflex/components/chatListItem.dart';
import 'package:eduflex/components/drawer.dart';
import 'package:eduflex/components/groupchat.dart';
import 'package:eduflex/components/personal_chat.dart';
import 'package:eduflex/pages/chatHome.dart';
import 'package:eduflex/pages/createGroup.dart';
import 'package:eduflex/pages/friends.dart';
import 'package:eduflex/pages/joinGroup.dart';
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
  bool ispersonalChat = true;
  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;

    getFriend();
  }

  void getFriend() async {
    // // List<dynamic> startedChat = await MyProvider.getStartedChat();
    // // setState(() {
    // //   _startedChat = startedChat;
    // // });
    // _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
    //   try {
    //     List<dynamic> startedChat = await MyProvider.getStartedChat();
    //     _streamController.add(startedChat);
    //   } catch (e) {
    //     print('Error: $e');
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        appBar: AppBar(
          shadowColor: Colors.black,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Chat Room "),
          centerTitle: true,
          actions: [profilepic(context)],
        ),
        drawer: MyDrawer(),
        body: Container(
          child: Column(
            children: [
              Container(
                color: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          ispersonalChat = true;
                        });
                      },
                      child: Column(
                        children: [
                          Icon(Icons.person),
                          SizedBox(
                            height: 5,
                          ),
                          ispersonalChat
                              ? Container(
                                  width: 35,
                                  height: 5,
                                  decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(3),
                                          topLeft: Radius.circular(3))),
                                )
                              : Container()
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          ispersonalChat = false;
                        });
                      },
                      child: Column(
                        children: [
                          Icon(Icons.group),
                          SizedBox(
                            height: 5,
                          ),
                          !ispersonalChat
                              ? Container(
                                  width: 35,
                                  height: 5,
                                  decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(3),
                                          topLeft: Radius.circular(3))),
                                )
                              : Container()
                        ],
                      ),
                    )
                  ],
                ),
              ),
              ispersonalChat ? PersonalChat() : GroupChat()
            ],
          ),
        ),
        floatingActionButton: ispersonalChat
            ? GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Friends()));
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: Icon(Icons.person),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => JoinGroup()));
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                          child: Text(
                        'Join',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateGroup()));
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                          child: Text('Create',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18))),
                    ),
                  )
                ],
              )

        // IconButton(
        //     onPressed: () {
        //       _timer.cancel();
        //       _streamController.close();
        //       Navigator.push(
        //           context, MaterialPageRoute(builder: (context) => Friends()));
        //     },
        //     icon: Icon(Icons.person)),
        );
  }

  @override
  void dispose() {
    // _timer.cancel();
    // _streamController.close();
    super.dispose();
  }
}
