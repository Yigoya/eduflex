import 'package:eduflex/components/UserProfile.dart';
import 'package:eduflex/components/auth.dart';
import 'package:eduflex/components/drawer.dart';
import 'package:eduflex/components/item.dart';
import 'package:eduflex/pages/PostClassRoom.dart';
import 'package:eduflex/pages/addClassRoomPost.dart';
import 'package:eduflex/provider.dart';
import 'package:eduflex/service/schema/user.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MyClassRoom extends StatefulWidget {
  final Map<String, dynamic> data;
  const MyClassRoom({super.key, required this.data});

  @override
  State<MyClassRoom> createState() => _MyClassRoomState();
}

class _MyClassRoomState extends State<MyClassRoom> {
  TextEditingController controller = TextEditingController();
  // List<dynamic> _post = [];
  @override
  void initState() {
    super.initState();
    // getClassRoomPost();
  }

  // void getClassRoomPost() async {
  //   int id = widget.data['id'] as int;
  //   List<dynamic> post = await MyProvider.getClassRoomPost(id);
  //   print(post);
  //   setState(() {
  //     _post = post;
  //   });
  // }

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
        child: Column(
          children: [
            Container(
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
                          '${widget.data['name']}',
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
                      height: 30,
                    ),
                    Text(
                      '${widget.data['name']}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostClassRoom(
                            id: widget.data['id'], data: widget.data)));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).primaryColorDark,
                        blurRadius: 0.4,
                        spreadRadius: 0.5,
                        offset: Offset(0.2, 0))
                  ],
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Row(
                  children: [
                    profilepic(context),
                    Text(
                      'Share with your class',
                      style: TextStyle(color: Colors.black.withOpacity(0.8)),
                    )
                  ],
                ),
              ),
            ),
            FutureBuilder(
                future: MyProvider.getClassRoomPost(widget.data['id']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While waiting for the Future to complete
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // If there is an error
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<dynamic> _post = snapshot.data!;
                    print(_post);
                    return Expanded(
                      child: ListView.builder(
                          itemCount: _post.length,
                          itemBuilder: (context, index) {
                            return VisibilityDetector(
                                key: Key(_post[index]['post']['id'].toString()),
                                onVisibilityChanged: (info) async {
                                  User? user = await MyProvider.user();
                                  if (info.visibleFraction > 0.0) {
                                    List list =
                                        _post[index]['post']['isSeen'] as List;
                                    if (!list.contains(user!.id)) {
                                      await MyProvider.setClassRoomSeen(
                                          _post[index]['post']['id']);
                                      print("visible visible visible");
                                    }
                                  }
                                },
                                child: classRoomPost(context, _post[index]));
                          }),
                    );
                  }
                }),
          ],
        ),
      ),
      // floatingActionButton: Container(
      //   height: 100,
      //   color: Colors.amberAccent,
      //   child: Column(
      //     children: [
      //       IconButton(
      //         onPressed: () {
      //           popForm(context);
      //         },
      //         icon: Icon(Icons.person_add),
      //       ),
      //       IconButton(
      //         onPressed: () {
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (context) =>
      //                       AddClassRoomPost(data: widget.data)));
      //         },
      //         icon: Icon(Icons.add),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  // void popForm(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return Dialog(
  //           child: Container(
  //             child: Column(
  //               children: [
  //                 Text("add student to your class room"),
  //                 textfield(controller, 'add student email'),
  //                 button(() {
  //                   int id = widget.data['id'] as int;
  //                   MyProvider.joinClassRoom(id, controller.text);
  //                 }, "Add")
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }
}
