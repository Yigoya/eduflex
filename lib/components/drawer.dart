import 'package:eduflex/auth/auth_gete.dart';
import 'package:eduflex/components/bottomnav.dart';
import 'package:eduflex/pages/ClassRoom.dart';
import 'package:eduflex/pages/Resource.dart';
import 'package:eduflex/pages/home.dart';
import 'package:eduflex/pages/matrix.dart';
import 'package:eduflex/provider.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blue[300],
      child: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildHeader(),
                dashboard("Dashboard", () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DashBoard()));
                }, Icons.dashboard),
                buildElement(),
                SizedBox(
                  height: 100,
                ),
                buildFooter()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Eduflex",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_circle_left_outlined,
              color: Colors.white,
            ))
      ],
    );
  }

  Widget buildElement() {
    return Container(
      margin: EdgeInsets.only(left: 30),
      child: Wrap(
        children: [
          element("Home", () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home()));
          }, Icons.home_filled),
          element("Matrix", () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Matrix()));
          }, Icons.question_mark),
          element("Class Room", () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ClassRoom()));
          }, Icons.class_),
          element("Resource", () {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Resource()));
          }, Icons.my_library_books)
        ],
      ),
    );
  }

  Widget buildFooter() {
    return Container(
      alignment: Alignment.bottomLeft,
      child: Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.dark_mode,
                    size: 35,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Change mood",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Switch(
                  value: _value,
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                    });
                  })
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            height: 1.0,
            color: Colors.blueGrey,
          ),
          element("Setting", () {
            print("setting");
          }, Icons.settings_suggest_outlined, isFooter: true),
          element("Log out", () async {
            await MyProvider.removeUser();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => AuthGate()),
                (route) => false);
          }, Icons.logout, isFooter: true),
        ],
      ),
    );
  }

  Widget element(String text, void Function() fun, IconData icon,
      {isFooter = false}) {
    return GestureDetector(
      onTap: fun,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: isFooter ? 30 : 35,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  text,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: isFooter ? 15 : 20,
                      fontWeight: isFooter ? FontWeight.w400 : FontWeight.w500),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              height: 1.0,
              color: Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboard(String text, void Function() fun, IconData icon,
      {isFooter = false}) {
    return GestureDetector(
      onTap: fun,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 118, 187, 221),
            border: Border.all(color: Colors.blueGrey),
            borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.only(top: 20),
        child: Row(
          children: [
            Icon(
              icon,
              size: isFooter ? 30 : 35,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: isFooter ? 15 : 20,
                  fontWeight: isFooter ? FontWeight.w400 : FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
