import 'package:eduflex/components/auth.dart';
import 'package:eduflex/components/drawer.dart';
import 'package:eduflex/pages/MyClassRoom.dart';
import 'package:eduflex/provider.dart';
import 'package:flutter/material.dart';

class AddClassRoomPost extends StatefulWidget {
  final Map<String, dynamic> data;
  const AddClassRoomPost({super.key, required this.data});

  @override
  State<AddClassRoomPost> createState() => _AddClassRoomPostState();
}

class _AddClassRoomPostState extends State<AddClassRoomPost> {
  List<String> list = ['HomeWork', 'Assigment', 'Exercise'];
  String? dropdownValue = 'HomeWork';
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Class Room"),
        centerTitle: true,
        actions: [profilepic()],
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          dropdown((value) {
            setState(() {
              dropdownValue = value;
            });
          }, list, dropdownValue),
          textfield(titleController, "Title"),
          textfield(textController, "your body"),
          button(() {
            int id = widget.data['id'] as int;
            MyProvider.createClassRoomPost(
                dropdownValue, id, titleController.text, textController.text);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => MyClassRoom(data: widget.data)),
                (route) => false);
          }, "Post")
        ],
      ),
    );
  }
}
