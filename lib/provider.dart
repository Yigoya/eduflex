import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eduflex/auth/auth_gete.dart';
import 'package:eduflex/service/dbservice.dart';
import 'package:eduflex/service/schema/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:path/path.dart';

class MyProvider {
  static Future<User?> user() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('user') ?? '';
    if (value == '') return null;
    return User.fromMap(jsonDecode(value));
  }

  static Future<void> setUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('user', jsonEncode(user.toMap()));
  }

  static Future<void> removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('user');
  }

  static String server = 'http://192.168.12.1:8000';
  static String wsserver = 'ws://192.168.12.1:8000';

  static Future<void> singin(
      String email, String password, BuildContext context) async {
    Dio dio = Dio();
    Map<String, dynamic> data = {"email": email, "password": password};
    try {
      // Make a GET request to a URL
      Response response =
          await dio.post('${server}/api/loginstudent/', data: data);
      print(response.data);
      await MyProvider.setUser(User.fromMap(response.data));
      User? user = await MyProvider.user();
      print(user!.name);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AuthGate()),
          (route) => false);
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
  }

  static Future<void> loadMatrix() async {
    DBservice dBservice = DBservice.instance;
    List<Map<String, Object?>> que = await dBservice.isEmpty();
    if (que[0]['count']! != 0) {
    } else {
      Dio dio = Dio();
      Response res = await dio.get('${server}/api/matrixall');
      List<dynamic> data = res.data;
      for (dynamic item in data) {
        Map<String, Object?> rec = item as Map<String, Object?>;
        print(rec['question']);
        dBservice.insertQue(rec);
      }
    }
  }

  static Future<Map<String, dynamic>> getusename(String name) async {
    User? _user = await user();
    Dio dio = Dio();
    Response res = await dio.get('${server}/api/getusername?name=${name}');

    Map<String, dynamic> data = res.data;

    return data;
  }

  static Future<List<dynamic>> getClassRoom() async {
    User? _user = await user();
    Dio dio = Dio();
    Response res = await dio.get('${server}/api/getclassroom/${_user!.id}');

    List<dynamic> data = res.data;

    return data;
  }

  static Future<List<dynamic>> getMyClassRoom() async {
    User? _user = await user();
    Dio dio = Dio();
    Response res = await dio.get('${server}/api/getmyclassroom/${_user!.id}');

    List<dynamic> data = res.data;

    return data;
  }

  static void createRoom(String name) async {
    Dio dio = Dio();
    User? _user = await user();
    Map<String, dynamic> data = {"teacher": _user!.id, "name": name};
    try {
      Response res =
          await dio.post('${server}/api/createclassroom', data: data);
      print(res.data);
    } catch (e) {
      print(e);
    }
  }

  static void createClassRoomPost(
      String? tasktype, int classroom, String title, String text) async {
    Dio dio = Dio();
    User? _user = await user();
    Map<String, dynamic> data = {
      "author": _user!.id,
      "classroom": classroom,
      'title': title,
      'text': text,
      'tasktype': tasktype
    };
    try {
      Response res = await dio.post('${server}/api/postclassroom/${_user!.id}',
          data: data);
      print(res.data);
    } catch (e) {
      print(e);
    }
  }

  static Future<List<dynamic>> getClassRoomPost(int classroom) async {
    User? _user = await user();
    Dio dio = Dio();
    Response res = await dio.get('${server}/api/postclassroom/${classroom}');

    List<dynamic> data = res.data;

    return data;
  }

  static void joinClassRoom(int classroom, String student) async {
    Dio dio = Dio();
    User? _user = await user();
    Map<String, dynamic> data = {"classroom": classroom, "student": student};
    try {
      Response res = await dio.post('${server}/api/joinclassroom', data: data);
      print(res.data);
    } catch (e) {
      print(e);
    }
  }

  static Future<Map<String, dynamic>> getUser(String email) async {
    User? _user = await user();
    Dio dio = Dio();
    Response res =
        await dio.get('${server}/api/student/${_user!.id}?email=$email');

    // List<dynamic> data = {'dl':2};
    print(res.data);
    // Response res2 = await dio.get('${server}/api/student/${_user!.id}');

    return res.data;
  }

  static Future<Map<String, dynamic>> getSignedUser() async {
    User? _user = await user();
    Dio dio = Dio();
    print("object");
    Response res = await dio.get('${server}/api/getstudent/${_user!.id}');

    // List<dynamic> data = {'dl':2};
    print(res.data);
    // Response res2 = await dio.get('${server}/api/student/${_user!.id}');

    return res.data;
  }

  static Future<List<dynamic>> getFriend() async {
    User? _user = await user();
    Dio dio = Dio();
    Response res = await dio.get('${server}/api/friend/${_user!.id}');

    // List<dynamic> data = {'dl':2};
    print(res.data);
    // Response res2 = await dio.get('${server}/api/student/${_user!.id}');

    return res.data;
  }

  static Future<List<dynamic>> getMessage(String roomid) async {
    User? _user = await user();
    Dio dio = Dio();
    Response res = await dio.get('${server}/api/message/$roomid');

    // List<dynamic> data = {'dl':2};
    print(res.data);
    // Response res2 = await dio.get('${server}/api/student/${_user!.id}');

    return res.data;
  }

  static Future<void> setFriend(int id) async {
    Dio dio = Dio();
    User? _user = await user();
    Map data = {
      'data': [id]
    };
    try {
      Response res =
          await dio.post('${server}/api/friend/${_user!.id}', data: data);
      print(res.data);
    } catch (e) {
      print(e);
    }
  }

  static Future<List<dynamic>> getStartedChat() async {
    User? _user = await user();
    Dio dio = Dio();
    Response res = await dio.get('${server}/api/mymessage/${_user!.id}');

    // List<dynamic> data = {'dl':2};
    print(res.data);
    // Response res2 = await dio.get('${server}/api/student/${_user!.id}');

    return res.data;
  }

  static Future<String> setStartChat(int id) async {
    Dio dio = Dio();
    User? _user = await user();
    List ids = [_user!.id, id];
    ids.sort();
    ids.toString();
    Map data = {
      'data': [ids.join(), id]
    };
    try {
      Response res =
          await dio.post('${server}/api/mymessage/${_user!.id}', data: data);
      return ids.join();
    } catch (e) {
      print(e);
      return 'n';
    }
  }

  static Future<void> setProfilePic(String filePath) async {
    User? _user = await user();
    Dio dio = Dio();
    Map<String, dynamic> data = await getSignedUser();

    data['avatar'] =
        await MultipartFile.fromFile(filePath, filename: basename(filePath));
    print(data);
    FormData formData = FormData.fromMap(data);
    try {
      Response res =
          await dio.put('${server}/api/student/${_user!.id}', data: formData);
      print(res.data);
    } catch (e) {
      print("Error $e");
    }
  }

  static Future<File?> getImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('profilepic') ?? '';
    print(value);
    if (value == '') return null;
    return File(value);
  }

  static Future<void> setActiveStatus(bool status) async {
    User? _user = await user();
    Dio dio = Dio();
    Response res = await dio
        .post('${server}/api/online/${_user!.id}', data: {'status': status});

    // List<dynamic> data = {'dl':2};
    print(res.data);
    // Response res2 = await dio.get('${server}/api/student/${_user!.id}');

    return res.data;
  }
}
