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

  static String server = 'http://192.168.254.17:8000';
  static String wsserver = 'ws://192.168.254.17:8000';

  static Future<void> singin(
      String email, String password, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.getString('token')!;
    Dio dio = Dio();
    Map<String, dynamic> data = {
      "email": email,
      "password": password,
      'token': token
    };
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
    } catch (e) {
      print(e);
    }
  }

  static void createClassRoomPost(String? tasktype, int classroom, String title,
      String text, String filetype, String? filePath) async {
    Dio dio = Dio();
    User? _user = await user();
    print('path in provider: $filePath');
    Map<String, dynamic> data = {
      "author": _user!.id,
      "classroom": classroom,
      'title': title,
      'text': text,
      'tasktype': tasktype
    };
    if (filePath != null) {
      data[filetype] =
          await MultipartFile.fromFile(filePath, filename: basename(filePath));
    }

    FormData formData = FormData.fromMap(data);
    try {
      Response res = await dio.post('${server}/api/postclassroom/${_user!.id}',
          data: formData);
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

  static Future<bool> joinClassRoom(int classroom) async {
    Dio dio = Dio();
    User? _user = await user();
    Map<String, dynamic> data = {"classroom": classroom, "student": _user!.id};
    try {
      Response res = await dio.post('${server}/api/joinclassroom', data: data);

      if (res.data['isExist'] == null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<bool> joinGroup(String groupid) async {
    Dio dio = Dio();
    User? _user = await user();
    Map<String, dynamic> data = {"group": groupid, "user": _user!.id};
    try {
      Response res = await dio.post('${server}/api/joingroup', data: data);

      if (res.data['isExist'] == null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> getUser(String name) async {
    User? _user = await user();
    Dio dio = Dio();
    Response res =
        await dio.get('${server}/api/student/${_user!.id}?name=$name');

    return res.data;
  }

  static Future<Map<String, dynamic>> getSignedUser() async {
    User? _user = await user();
    Dio dio = Dio();
    print("object");
    Response res = await dio.get('${server}/api/getstudent/${_user!.id}');

    return res.data;
  }

  static Future<List<dynamic>> getFriend() async {
    User? _user = await user();
    Dio dio = Dio();
    Response res = await dio.get('${server}/api/friend/${_user!.id}');

    return res.data;
  }

  static Future<List<dynamic>> getMessage(String roomid) async {
    User? _user = await user();
    Dio dio = Dio();
    Response res = await dio.get('${server}/api/message/$roomid');

    return res.data;
  }

  static Future<List<dynamic>> getGroupMessage(String roomid) async {
    User? _user = await user();
    Dio dio = Dio();
    Response res = await dio.get('${server}/api/mygroup/$roomid');

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
    } catch (e) {
      print(e);
    }
  }

  static Future<List<dynamic>> getStartedChat() async {
    User? _user = await user();
    Dio dio = Dio();
    Response res = await dio.get('${server}/api/mymessage/${_user!.id}');

    return res.data;
  }

  static Future<List<dynamic>> getGroupChat() async {
    User? _user = await user();
    Dio dio = Dio();
    Response res = await dio.get('${server}/api/group/${_user!.id}');

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

  static Future<String> createGroup(String name, String idname) async {
    Dio dio = Dio();
    User? _user = await user();

    Map data = {'creator': _user!.id, 'name': name, 'idname': idname};
    try {
      Response res =
          await dio.post('${server}/api/group/${_user!.id}', data: data);
      return idname;
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
    print('CHECK: $data');
    FormData formData = FormData.fromMap(data);
    try {
      Response res = await dio.put('${server}/api/setprofile/${_user!.id}',
          data: formData);
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

    return res.data;
  }

  static Future<void> setClassRoomSeen(int id) async {
    User? _user = await user();
    Dio dio = Dio();
    Response res =
        await dio.get('${server}/api/classroomseen/$id?id=${_user!.id}');

    return res.data;
  }

  static Future<List<dynamic>> getUnseen(String roomid) async {
    User? _user = await user();
    Dio dio = Dio();
    Response res =
        await dio.get('${server}/api/chatseen/$roomid?id=${_user!.id}');

    return res.data;
  }

  static Future<void> setChatSeen(int id) async {
    User? _user = await user();
    Dio dio = Dio();
    Response res = await dio.post('${server}/api/chatseen/$id?id=${_user!.id}');

    return res.data;
  }

  static Future<List<dynamic>> getNotification() async {
    User? _user = await user();
    Dio dio = Dio();
    Response res = await dio.get('${server}/api/notification/${_user!.id}');

    return res.data;
  }
}
