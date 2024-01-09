import 'package:eduflex/components/auth.dart';
import 'package:eduflex/components/drawer.dart';
import 'package:eduflex/pages/ClassRoom.dart';
import 'package:eduflex/pages/chat.dart';
import 'package:eduflex/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JoinGroup extends StatefulWidget {
  const JoinGroup({super.key});

  @override
  State<JoinGroup> createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  TextEditingController controller = TextEditingController();
  bool _error = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Class Room"),
        centerTitle: true,
        actions: [profilepic(context)],
      ),
      drawer: MyDrawer(),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('write the correct id name of the group'),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Theme.of(context).cardColor)),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                    hintText: 'group id name', border: InputBorder.none),
              ),
            ),
            GestureDetector(
              onTap: () async {
                bool isExist = await MyProvider.joinGroup(controller.text);
                if (isExist) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Chat()),
                      (route) => false);
                } else {
                  setState(() {
                    _error = true;
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _error
                      ? Container(
                          child: Text(
                            'Group doesn\'t exist',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : Container(),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      'Join',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
