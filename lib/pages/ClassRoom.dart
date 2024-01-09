import 'package:dio/dio.dart';
import 'package:eduflex/components/auth.dart';
import 'package:eduflex/components/drawer.dart';
import 'package:eduflex/pages/CreateClassRoom.dart';
import 'package:eduflex/pages/JoinClassRoom.dart';
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
  // List<dynamic> _clasroom = [];
  // List<dynamic> _myclasroom = [];
  @override
  void initState() {
    super.initState();
    // getClasRoom();
  }

  // void getClasRoom() async {
  //   List<dynamic> classroom = await
  //   List<dynamic> myclassroom = await MyProvider.getMyClassRoom();
  //   print(classroom);
  //   setState(() {
  //     _clasroom = classroom;
  //     _myclasroom = myclassroom;
  //   });
  // }
  bool isExist = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Class Room"),
        centerTitle: true,
        actions: [profilepic(context)],
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          FutureBuilder(
              future: MyProvider.getClassRoom(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While waiting for the Future to complete
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // If there is an error
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<dynamic> _clasroom = snapshot.data!;

                  return Expanded(
                    child: ListView.builder(
                        itemCount: _clasroom.length,
                        itemBuilder: (context, index) {
                          print(_clasroom.length);

                          return GestureDetector(
                              onTap: () {
                                Map<String, dynamic> data = _clasroom[index]
                                    ['classrrom'] as Map<String, dynamic>;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MyClassRoom(data: data)));
                              },
                              child: ClassCard(_clasroom[index]));
                        }),
                  );
                }
              }),

          // !isExist
          //     ? SizedBox(
          //         height: 500,
          //         child: Center(
          //           child: Container(
          //             child: IconButton(
          //               onPressed: () {
          //                 popForm(context);
          //               },
          //               icon: Icon(Icons.add),
          //             ),
          //           ),
          //         ),
          //       )
          //     : Container()
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
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateClassRoom()));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Create New',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                  )),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JoinClassRoom()));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Join Class',
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

  Widget ClassMyCard(Map<String, dynamic> data) {
    // DateTime dateTime = DateTime.parse(data['created']);
    return Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.purple[900],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${data['name']}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.more_vert, color: Colors.white))
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'Your Class Room',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ));
  }

  Widget ClassCard(Map<String, dynamic> data) {
    // DateTime dateTime = DateTime.parse(data['created']);
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(255, 5, 114, 54),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${data['classrrom']['name']}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ))
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              '${data['creator']['name']}',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ));
  }
}
