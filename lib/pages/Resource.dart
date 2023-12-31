import 'package:eduflex/components/auth.dart';
import 'package:eduflex/components/drawer.dart';
import 'package:flutter/material.dart';

class Resource extends StatefulWidget {
  const Resource({super.key});

  @override
  State<Resource> createState() => _ResourceState();
}

class _ResourceState extends State<Resource> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resources"),
        centerTitle: true,
        actions: [profilepic()],
      ),
      drawer: MyDrawer(),
    );
    ;
  }
}
