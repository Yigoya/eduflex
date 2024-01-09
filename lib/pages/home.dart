import 'dart:async';

import 'package:eduflex/auth/auth_gete.dart';
import 'package:eduflex/components/auth.dart';
import 'package:eduflex/components/bottomnav.dart';
import 'package:eduflex/components/drawer.dart';
import 'package:eduflex/components/notify_icon.dart';
import 'package:eduflex/pages/notification.dart';
import 'package:eduflex/provider.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Timer _timer;
  late StreamConsumer _streamConsumer;
  late Stream _stream;
  @override
  void initState() {
    super.initState();
    getState();
  }

  void getState() async {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      try {
        print('object');
      } catch (e) {
        print('Error: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eduflex"),
        centerTitle: true,
        actions: [NotifyIcon(), profilepic(context)],
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
