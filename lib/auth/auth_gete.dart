import 'dart:convert';

import 'package:eduflex/components/bottomnav.dart';
import 'package:eduflex/pages/home.dart';
import 'package:eduflex/pages/login.dart';
import 'package:eduflex/pages/loginorregister..dart';
import 'package:eduflex/provider.dart';
import 'package:eduflex/service/schema/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  MyProvider _provider = MyProvider();
  User? _user = null;
  @override
  void initState() {
    super.initState();
    user();
  }

  void user() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('user') ?? '';
    if (value != '') {
      setState(() {
        _user = User.fromMap(jsonDecode(value));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user != null) {
      return DashBoard();
    } else {
      return LogOrReg();
    }
  }
}
