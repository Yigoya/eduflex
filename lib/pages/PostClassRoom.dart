import 'dart:io';

import 'package:eduflex/components/auth.dart';
import 'package:eduflex/components/drawer.dart';
import 'package:eduflex/pages/ClassRoom.dart';
import 'package:eduflex/pages/MyClassRoom.dart';
import 'package:eduflex/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class PostClassRoom extends StatefulWidget {
  final int id;
  final Map<String, dynamic> data;
  const PostClassRoom({super.key, required this.id, required this.data});

  @override
  State<PostClassRoom> createState() => _PostClassRoomState();
}

class _PostClassRoomState extends State<PostClassRoom> {
  TextEditingController _typecontroller = TextEditingController();
  TextEditingController _titlecontroller = TextEditingController();
  TextEditingController _bodycontroller = TextEditingController();
  // TextEditingController controller = TextEditingController();
  // MyProvider.createClassRoomPost(tasktype, classroom, title, text)
  bool _error = false;
  File? _file;
  String? filePath;
  String filetype = 'image';
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _file = File(image.path);
        filetype = 'image';
        filePath = image.path;
      });
    }
  }

  Future<void> pickFile() async {
    final file = await FilePicker.platform.pickFiles();
    if (file != null) {
      setState(() {
        _file = File(file.files.first.path!);
        filetype = 'file';
        filePath = file.files.first.path!;
      });
    }
  }

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
            Text('Give the name for Your Class Room'),
            input(_typecontroller, 'type ex. Homework'),
            input(_titlecontroller, 'title'),
            input(_bodycontroller, 'main body'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _file != null ? Text(basename(_file!.path)) : Container(),
                IconButton(
                    onPressed: () {
                      popForm(context);
                    },
                    icon: Icon(Icons.attach_file)),
              ],
            ),
            GestureDetector(
              onTap: () async {
                print('path:nni: ${_file!.path}');
                MyProvider.createClassRoomPost(
                    _typecontroller.text,
                    widget.id,
                    _titlecontroller.text,
                    _bodycontroller.text,
                    filetype,
                    filePath);

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyClassRoom(
                              data: widget.data,
                            )),
                    (route) => false);
              },
              child: Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(5)),
                child: Text(
                  'Post',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget input(TextEditingController controller, String hint) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black54)),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: hint, border: InputBorder.none),
      ),
    );
  }

  void popForm(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(9))),
      context: context,
      builder: (BuildContext context) {
        // Return the content of the bottom sheet
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                  onTap: () async {
                    await pickImage();
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Attack Image',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                  )),
              GestureDetector(
                  onTap: () async {
                    await pickFile();
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Attack File',
                      style: TextStyle(
                          fontSize: 16, color: Colors.black.withOpacity(0.8)),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}
