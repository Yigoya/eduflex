import 'package:dio/dio.dart';
import 'package:eduflex/auth/auth_gete.dart';
import 'package:eduflex/components/auth.dart';
import 'package:eduflex/doc/language.dart';
import 'package:eduflex/provider.dart';
import 'package:eduflex/service/schema/user.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final void Function() fun;
  const LoginPage({super.key, required this.fun});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Asset asset = Asset();
  // Map<String, String> _lang = {};
  // @override
  // void initState() {
  //   super.initState();
  //   getLang();
  // }

  // void getLang() async {
  //   Map<String, String> lang = await asset.lang;
  //   setState(() {
  //     _lang = lang;
  //   });
  // }

  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  void onTap() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.indigo[50]),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                ),
                Text(
                  'Log in',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                textfield(_emailcontroller, 'email or username'),
                SizedBox(
                  height: 20,
                ),
                textfield(_passwordcontroller, 'password', isPass: true),
                SizedBox(
                  height: 30,
                ),
                button(() {
                  MyProvider.singin(
                      _emailcontroller.text, _passwordcontroller.text, context);
                }, 'sign in'),
                button(widget.fun, 'create new', border: false)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
