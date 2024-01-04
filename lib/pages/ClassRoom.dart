import 'package:dio/dio.dart';
import 'package:eduflex/components/auth.dart';
import 'package:eduflex/components/drawer.dart';
import 'package:eduflex/pages/MyClassRoom.dart';
import 'package:eduflex/provider.dart';
import 'package:flutter/material.dart';

class ClassRoom extends StatefulWidget {
  const ClassRoom({super.key});

  @override
  State<ClassRoom> createState() => _ClassRoomState();
}

class _ClassRoomState extends State<ClassRoom> {
  TextEditingController controller = TextEditingController();
  List<dynamic> _clasroom = [];
  List<dynamic> _myclasroom = [];
  @override
  void initState() {
    super.initState();
    getClasRoom();
  }

  void getClasRoom() async {
    List<dynamic> classroom = await MyProvider.getClassRoom();
    List<dynamic> myclassroom = await MyProvider.getMyClassRoom();
    print(classroom);
    setState(() {
      _clasroom = classroom;
      _myclasroom = myclassroom;
    });
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
        child: Column(children: [
          Text("data"),
          Text("My class room"),
          SizedBox(
            width: 300,
            height: 100,
            child: ListView.builder(
                itemCount: _myclasroom.length == 0 ? 1 : _myclasroom.length,
                itemBuilder: (context, index) {
                  print(_myclasroom.length);
                  if (_myclasroom.length > 0) {
                    return GestureDetector(
                        onTap: () {
                          Map<String, dynamic> data =
                              _myclasroom[index] as Map<String, dynamic>;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyClassRoom(data: data)));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            width: 100,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${_myclasroom[index]['name']}'),
                                Text(
                                    'day created: ${_myclasroom[index]['created']}'),
                              ],
                            )));
                  } else {
                    return GestureDetector(
                      onTap: () {
                        popForm(context);
                      },
                      child: Container(
                        width: 100,
                        height: 50,
                        child: Text("create classroom"),
                      ),
                    );
                  }
                }),
          ),
          SizedBox(
            height: 80,
          ),
          Text("class rooms: "),
          Expanded(
            child: ListView.builder(
                itemCount: _clasroom.length == 0 ? 1 : _clasroom.length,
                itemBuilder: (context, index) {
                  print(_clasroom.length);
                  if (_clasroom.length > 0) {
                    return Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        width: 100,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${_clasroom[index]['classrrom']['name']}'),
                            Text('${_clasroom[index]['creator']['name']}'),
                          ],
                        ));
                  } else {
                    return GestureDetector(
                      onTap: () {
                        popForm(context);
                      },
                      child: Container(
                        child: Text("join classroom"),
                      ),
                    );
                  }
                }),
          )

          // _clasroom.length == 0 ? newClass(context) : getClass(_myclasroom),
          // _myclasroom.length == 0 ? newClass(context) : getClass(_clasroom),
        ]),
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          popForm(context);
        },
        icon: Icon(Icons.add),
      ),
    );
  }

  void popForm(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              child: Column(
                children: [
                  Text("Create room"),
                  textfield(controller, "class room name"),
                  button(() {
                    MyProvider.createRoom(controller.text);
                    Navigator.pop(context);
                  }, "Create")
                ],
              ),
            ),
          );
        });
  }
}
