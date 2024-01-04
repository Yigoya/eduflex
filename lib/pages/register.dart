import 'package:dio/dio.dart';
import 'package:eduflex/auth/auth_gete.dart';
import 'package:eduflex/components/auth.dart';
import 'package:eduflex/provider.dart';
import 'package:eduflex/service/schema/user.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final void Function() fun;
  const Register({super.key, required this.fun});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _usernamecontroller = TextEditingController();
  TextEditingController _fullnamecontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  TextEditingController _confimpasswordcontroller = TextEditingController();
  TextEditingController _profcontroller = TextEditingController();
  TextEditingController _gradecontroller = TextEditingController();
  TextEditingController _schoolcontroller = TextEditingController();

  bool isDetail = false;
  void toggle() {
    setState(() {
      isDetail = !isDetail;
    });
  }

  List<dynamic>? _error = null;
  bool wrong = false;
  bool isnotfill = false;
  bool next() {
    if (!isUsed!) {
      return false;
    }
    if (_emailcontroller.text != '' &&
        _usernamecontroller.text != '' &&
        _passwordcontroller.text != '') {
      if (_confimpasswordcontroller.text != _passwordcontroller.text) {
        setState(() {
          wrong = true;
        });
        return false;
      } else {
        return true;
      }
    } else {
      setState(() {
        isnotfill = true;
      });
      return false;
    }
  }

  void singup() async {
    if (!next()) return;
    Dio dio = Dio();
    Map<String, dynamic> data = {
      "name": _fullnamecontroller.text,
      "username": _usernamecontroller.text,
      "email": _emailcontroller.text,
      "password": _passwordcontroller.text,
      // dropdownValue == 'student' ? 'grade' : 'graderange':
      //     dropdownValue == 'student' ? _gradeValue : _graderangeValue,
      // "schoolname": _schoolcontroller.text
    };
    try {
      // Make a GET request to a URL
      String url = '/api/createstudent/';
      Response response = await dio.post(MyProvider.server + url, data: data);
      if (response.statusCode == 404) {
        setState(() {
          _error;
        });
      }
      await MyProvider.singin(
          _emailcontroller.text, _passwordcontroller.text, context);
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
  }

  bool? isUsed;
  void onChange(value) async {
    Map<String, dynamic> data =
        await MyProvider.getusename(_usernamecontroller.text);
    setState(() {
      isUsed = data['isUsed'];
    });
  }

  // List<String> _list = ['student', 'teacher'];
  // List<String> _grade = ['7', '8', '9', '10', '11', '12'];
  // List<String> _graderange = ['7-8', '9-10', '9-12', '11-12'];
  // String dropdownValue = 'student';
  // String _gradeValue = '7';
  // String _graderangeValue = '7-8';
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
                  height: 150,
                ),
                Text(
                  'Register',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                isnotfill
                    ? Text(
                        'fill all neccessery form',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      )
                    : Container(),
                textfield(_fullnamecontroller, 'Full Name'),
                TextField(
                  onChanged: onChange,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  controller: _usernamecontroller,
                  decoration: InputDecoration(
                      hintText: "set username", border: InputBorder.none),
                ),
                isUsed != null
                    ? Container(
                        child: Text(
                          isUsed!
                              ? 'user name used'
                              : 'user name available use',
                          style: TextStyle(
                              color: isUsed! ? Colors.red : Colors.green),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 20,
                ),
                textfield(_emailcontroller, 'email '),
                SizedBox(
                  height: 20,
                ),
                textfield(_passwordcontroller, 'password'),
                SizedBox(
                  height: 20,
                ),
                textfield(_confimpasswordcontroller, 'confirm password'),
                SizedBox(
                  height: 20,
                ),
                wrong
                    ? Text(
                        'wrong password',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      )
                    : Container(),
                SizedBox(
                  height: 20,
                ),
                button(singup, 'sign up'),
                button(widget.fun, 'already have account', border: false)
              ],
            ),
          ),
        ),
      ),
    );
    // : (Scaffold(
    //     appBar: AppBar(
    //       leading: IconButton(
    //         onPressed: () {
    //           setState(() {
    //             isDetail = false;
    //           });
    //         },
    //         icon: Icon(Icons.arrow_circle_left_outlined),
    //       ),
    //     ),
    //     body: SingleChildScrollView(
    //       child: Container(
    //         padding: EdgeInsets.only(bottom: 100),
    //         decoration: BoxDecoration(color: Colors.indigo[50]),
    //         child: Center(
    //           child: Column(
    //             children: [
    //               SizedBox(
    //                 height: 200,
    //               ),
    //               Text(
    //                 'Detail info about your self',
    //                 style: TextStyle(
    //                     fontSize: 25, fontWeight: FontWeight.bold),
    //               ),
    //               SizedBox(
    //                 height: 30,
    //               ),
    //               _error != null
    //                   ? ListView.builder(
    //                       itemCount: _error!.length,
    //                       itemBuilder: (context, index) {
    //                         return Text(
    //                           _error![index],
    //                           style: TextStyle(
    //                               fontSize: 15,
    //                               fontWeight: FontWeight.bold,
    //                               color: Colors.red),
    //                         );
    //                       },
    //                     )
    //                   : Container(),
    //               Container(
    //                 width: 300,
    //                 margin: EdgeInsets.symmetric(horizontal: 40),
    //                 padding:
    //                     EdgeInsets.symmetric(horizontal: 20, vertical: 7),
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(20),
    //                     color: Colors.white),
    //                 child: dropdown((String? value) {
    //                   // This is called when the user selects an item.
    //                   print(value);
    //                   setState(() {
    //                     dropdownValue = value!;
    //                   });
    //                 }, _list, dropdownValue),
    //               ),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               Container(
    //                 width: 300,
    //                 padding:
    //                     EdgeInsets.symmetric(horizontal: 20, vertical: 7),
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(20),
    //                     color: Colors.white),
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Text(
    //                       dropdownValue == 'student'
    //                           ? 'grade: '
    //                           : 'grade range: ',
    //                       style: const TextStyle(
    //                           fontSize: 25, color: Colors.black),
    //                     ),
    //                     dropdownValue == 'student'
    //                         ? dropdown((String? value) {
    //                             // This is called when the user selects an item.
    //                             print(value);
    //                             setState(() {
    //                               _gradeValue = value!;
    //                             });
    //                           }, _grade, _gradeValue)
    //                         : dropdown((String? value) {
    //                             // This is called when the user selects an item.
    //                             setState(() {
    //                               _graderangeValue = value!;
    //                             });
    //                           }, _graderange, _graderangeValue),
    //                   ],
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: 20,
    //               ),
    //               textfield(_schoolcontroller, 'school name'),
    //               SizedBox(
    //                 height: 30,
    //               ),
    //               button(singup, 'finish')
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ));
  }
}
