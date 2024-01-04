import 'package:eduflex/auth/auth_gete.dart';
import 'package:eduflex/components/auth.dart';
import 'package:eduflex/components/bottomnav.dart';
import 'package:eduflex/components/drawer.dart';
import 'package:eduflex/provider.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eduflex"),
        centerTitle: true,
        actions: [profilepic(context)],
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Text('home'),
        ],
      ),
    );
  }
}
