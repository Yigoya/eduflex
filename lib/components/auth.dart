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

Widget profilepic() {
  return GestureDetector(
      child: Container(
    margin: EdgeInsets.only(right: 20),
    child: CircleAvatar(
      backgroundImage: AssetImage('assets/image/profile.jpeg'),
    ),
  ));
}
