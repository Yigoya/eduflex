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
  List<dynamic> _startedChat = [];

  @override
  void initState() {
    super.initState();
    getFriend();
  }

  void getFriend() async {
    List<dynamic> startedChat = await MyProvider.getStartedChat();
    setState(() {
      _startedChat = startedChat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Class Room"),
          centerTitle: true,
          actions: [profilepic()],
        ),
        drawer: MyDrawer(),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount:
                        _startedChat.length == 0 ? 1 : _startedChat.length,
                    itemBuilder: (context, i) {
                      if (_startedChat.length != 0) {
                        Map<String, dynamic> data =
                            _startedChat[i] as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                          data: data,
                                        )));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            padding: EdgeInsets.only(left: 23),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                border: Border.all(color: Colors.brown)),
                            child: Column(
                              children: [
                                Text(
                                  '${data['user']['name']}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('${data['msg']['body']}'),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Text("you have no chat");
                      }
                    }),
              ),
            ],
          ),
        ),
        floatingActionButton: IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Friends()));
            },
            icon: Icon(Icons.person)),
      ),
    );
  }
}
