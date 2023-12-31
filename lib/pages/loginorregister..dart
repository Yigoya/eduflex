import 'package:eduflex/pages/login.dart';
import 'package:eduflex/pages/register.dart';
import 'package:flutter/material.dart';

class LogOrReg extends StatefulWidget {
  const LogOrReg({super.key});

  @override
  State<LogOrReg> createState() => _LogOrRegState();
}

class _LogOrRegState extends State<LogOrReg> {
  bool isLogin = true;
  void toggle() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return LoginPage(fun: toggle);
    } else {
      return Register(fun: toggle);
    }
  }
}
