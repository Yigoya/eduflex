import 'package:eduflex/components/UserProfile.dart';
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
  @override
  void initState() {
    super.initState();
    getFriend();
  }

  void getFriend() async {
    // List<dynamic> friends = await ;
    // setState(() {
    //   _friends = friends;
    // });
  }

  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        appBar: AppBar(
          title: Text("Friends"),
          centerTitle: true,
          actions: [profilepic(context)],
        ),
        drawer: MyDrawer(),
        body: Container(
          child: Column(
            children: [
              FutureBuilder(
                  future: MyProvider.getFriend(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While waiting for the Future to complete
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // If there is an error
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<dynamic> _friends = snapshot.data!;
                      return Expanded(
                        child: ListView.builder(
                            itemCount:
                                _friends.length == 0 ? 1 : _friends.length,
                            itemBuilder: (context, i) {
                              if (_friends.length != 0) {
                                Map<String, dynamic> data =
                                    _friends[i] as Map<String, dynamic>;
                                print(data);
                                return GestureDetector(
                                    onTap: () async {
                                      String roomid =
                                          await MyProvider.setStartChat(
                                              data['id']);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ChatScreen(
                                                  data: data,
                                                  isNew: true,
                                                  roomid: roomid)));
                                    },
                                    child: UserProfile(data: data));
                              } else {
                                return Text("add friend");
                              }
                            }),
                      );
                    }
                  })
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
