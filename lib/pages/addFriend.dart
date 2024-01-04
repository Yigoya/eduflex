import 'package:eduflex/components/UserProfile.dart';
import 'package:eduflex/components/auth.dart';
import 'package:eduflex/components/drawer.dart';
import 'package:eduflex/pages/friends.dart';
import 'package:eduflex/provider.dart';
import 'package:flutter/material.dart';

class AddFriends extends StatefulWidget {
  const AddFriends({super.key});

  @override
  State<AddFriends> createState() => _AddFriendsState();
}

class _AddFriendsState extends State<AddFriends> {
  Map<String, dynamic> _friends = {};
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // getFriend();
  }

  Future<void> getFriend() async {
    Map<String, dynamic> friends = await MyProvider.getUser(controller.text);
    setState(() {
      _friends = friends;
    });
  }

  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Find Friend"),
          centerTitle: true,
          actions: [profilepic(context)],
        ),
        drawer: MyDrawer(),
        body: Container(
          child: Column(
            children: [
              textfield(controller, 'search by email'),
              button(() async {
                await getFriend();
              }, "search"),
              GestureDetector(
                  onTap: () async {
                    await MyProvider.setFriend(_friends['id']);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Friends()));
                  },
                  child: Container(
                    margin: EdgeInsets.all(30),
                    child: _friends['name'] != null
                        ? UserProfile(data: _friends)
                        : Text('search for friend'),
                  ))
            ],
          ),
        ),
        floatingActionButton:
            IconButton(onPressed: () {}, icon: Icon(Icons.add)),
      ),
    );
  }
}
