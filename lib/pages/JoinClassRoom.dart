import 'package:eduflex/components/auth.dart';
import 'package:eduflex/components/drawer.dart';
import 'package:eduflex/pages/ClassRoom.dart';
import 'package:eduflex/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JoinClassRoom extends StatefulWidget {
  const JoinClassRoom({super.key});

  @override
  State<JoinClassRoom> createState() => _JoinClassRoomState();
}

class _JoinClassRoomState extends State<JoinClassRoom> {
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
            Text('Ask your teacher for the class code then enter it here'),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Theme.of(context).cardColor)),
              child: TextField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: controller,
                decoration: InputDecoration(
                    hintText: 'Class Code', border: InputBorder.none),
              ),
            ),
            GestureDetector(
              onTap: () async {
                bool isExist =
                    await MyProvider.joinClassRoom(int.parse(controller.text));
                if (isExist) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => ClassRoom()),
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
                            'Class Room doesn\'t exist',
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
