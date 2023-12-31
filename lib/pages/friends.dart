import 'package:eduflex/components/auth.dart';
import 'package:eduflex/components/drawer.dart';
import 'package:eduflex/pages/addFriend.dart';
import 'package:eduflex/pages/chatHome.dart';
import 'package:eduflex/provider.dart';
import 'package:flutter/material.dart';

class Friends extends StatefulWidget {
  const Friends({super.key});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  List<dynamic> _friends = [];

  @override
  void initState() {
    super.initState();
    getFriend();
  }

  void getFriend() async {
    List<dynamic> friends = await MyProvider.getFriend();
    setState(() {
      _friends = friends;
    });
  }

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
                    itemCount: _friends.length == 0 ? 1 : _friends.length,
                    itemBuilder: (context, i) {
                      if (_friends.length != 0) {
                        Map<String, dynamic> data =
                            _friends[i] as Map<String, dynamic>;
                        print(data);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                          data: data,
                                          isNew: true,
                                        )));
                          },
                          child: Container(
                            margin: EdgeInsets.all(30),
                            child: Column(
                              children: [
                                Text('${data['name']}'),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Text("add friend");
                      }
                    }),
              ),
            ],
          ),
        ),
        floatingActionButton: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddFriends()));
            },
            icon: Icon(Icons.add)),
      ),
    );
  }
}
