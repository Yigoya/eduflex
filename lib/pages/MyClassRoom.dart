import 'package:eduflex/components/auth.dart';
import 'package:eduflex/components/drawer.dart';
import 'package:eduflex/pages/addClassRoomPost.dart';
import 'package:eduflex/provider.dart';
import 'package:flutter/material.dart';

class MyClassRoom extends StatefulWidget {
  final Map<String, dynamic> data;
  const MyClassRoom({super.key, required this.data});

  @override
  State<MyClassRoom> createState() => _MyClassRoomState();
}

class _MyClassRoomState extends State<MyClassRoom> {
  TextEditingController controller = TextEditingController();
  List<dynamic> _post = [];
  @override
  void initState() {
    super.initState();
    getClassRoomPost();
  }

  void getClassRoomPost() async {
    int id = widget.data['id'] as int;
    List<dynamic> post = await MyProvider.getClassRoomPost(id);
    print(post);
    setState(() {
      _post = post;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Class Room"),
        centerTitle: true,
        actions: [profilepic()],
      ),
      drawer: MyDrawer(),
      body: Container(
          child: Expanded(
        child: ListView.builder(
            itemCount: _post.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(8),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black38)),
                child: Column(
                  children: [
                    Text('${_post[index]['title']}'),
                    Text('${_post[index]['tasktype']}'),
                    Text('${_post[index]['text']}'),
                  ],
                ),
              );
            }),
      )),
      floatingActionButton: Container(
        height: 100,
        color: Colors.amberAccent,
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                popForm(context);
              },
              icon: Icon(Icons.person_add),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddClassRoomPost(data: widget.data)));
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  void popForm(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              child: Column(
                children: [
                  Text("add student to your class room"),
                  textfield(controller, 'add student email'),
                  button(() {
                    int id = widget.data['id'] as int;
                    MyProvider.joinClassRoom(id, controller.text);
                  }, "Add")
                ],
              ),
            ),
          );
        });
  }
}
