import 'dart:io';

import 'package:eduflex/pages/profile.dart';
import 'package:eduflex/provider.dart';
import 'package:flutter/material.dart';

Widget textfield(TextEditingController controller, String text) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 40),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), color: Colors.white),
    child: TextField(
      style: TextStyle(
        fontSize: 20,
      ),
      controller: controller,
      decoration: InputDecoration(hintText: text, border: InputBorder.none),
    ),
  );
}

Widget button(void Function() fun, String text,
    {bool border = true, Color? color}) {
  return GestureDetector(
    onTap: fun,
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      decoration: border
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: color ?? Color.fromARGB(255, 13, 88, 138))
          : null,
      child: Text(
        text,
        style: border
            ? TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)
            : TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget dropdown(void Function(String? value) fun, List<String> list,
    String? dropdownValue) {
  return DropdownButton<String>(
    padding: EdgeInsets.all(5),
    value: dropdownValue,
    icon: const Icon(Icons.arrow_drop_down_circle_sharp),
    elevation: 19,
    style: const TextStyle(fontSize: 25, color: Colors.black),
    underline: Container(
      height: 2,
      color: Colors.deepPurpleAccent,
    ),
    onChanged: fun,
    items: list.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
  );
}

Widget profilepic(BuildContext context) {
  return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Profile()));
      },
      child: FutureBuilder(
          future: MyProvider.getImage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for the Future to complete
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // If there is an error
              return Text('Error: ${snapshot.error}');
            } else {
              // If the Future has completed successfully
              return Container(
                  margin: EdgeInsets.only(right: 20),
                  child: ClipOval(
                    child: snapshot.data == null
                        ? Image.asset(
                            'assets/image/profile.jpeg',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            snapshot.data!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                  ));
            }
          }));
}

Widget userProfilepPic(
    BuildContext context, String? url, String name, bool stutas) {
  return Container(
      margin: EdgeInsets.only(right: 20),
      child: Stack(children: [
        ClipOval(
            child: url == null
                ? Container(
                    width: 50,
                    height: 50,
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        name[0].toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 26),
                      ),
                    ),
                  )
                : Image.network(
                    '${MyProvider.server}$url',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Theme.of(context).primaryColorLight, width: 1.5),
                color: stutas ? Colors.green : Colors.grey[400]),
            width: 15,
            height: 15,
          ),
        )
      ]));
}
