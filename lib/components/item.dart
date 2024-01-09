import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eduflex/components/UserProfile.dart';
import 'package:eduflex/pages/imagepage.dart';
import 'package:eduflex/provider.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

Widget matrixq() {
  return Container(
    child: Column(
      children: [Row()],
    ),
  );
}

Widget classRoomPost(BuildContext context, Map<String, dynamic> data) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Theme.of(context).primaryColorLight,
      boxShadow: [
        BoxShadow(
            color: Theme.of(context).primaryColorDark,
            blurRadius: 0.4,
            spreadRadius: 0.5,
            offset: Offset(0.2, 0))
      ],
      borderRadius: BorderRadius.circular(9),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UserProfile(data: data['user']),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 2, 100, 2)),
                child: Text(
                  '${data['post']['tasktype']}',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${data['post']['title']}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text('${data['post']['text']}'),
            data['post']['image'] != null
                ? imageView(context, data['post']['image'])
                : Container(),
            data['post']['file'] != null
                ? fileView(data['post']['file'])
                : Container()
          ],
        ),
      ],
    ),
  );
}

Widget chatMessage(BuildContext context, Map<String, dynamic> data) {
  DateTime dateTime = DateTime.parse(data['chat']['created']);
  String amPm = (dateTime.hour < 12) ? 'AM' : 'PM';
  String time = '${dateTime.hour}:${dateTime.minute} $amPm';
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Theme.of(context).primaryColorLight,
      boxShadow: [
        BoxShadow(
            color: Theme.of(context).primaryColorDark,
            blurRadius: 0.4,
            spreadRadius: 0.5,
            offset: Offset(0.2, 0))
      ],
      borderRadius: BorderRadius.circular(9),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UserProfile(data: data['user']),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 2, 100, 2)),
                child: Text(
                  '${time}',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          '${data['chat']['body']}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

Widget imageView(BuildContext context, String path) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ImagePage(path: MyProvider.server + path)));
    },
    child: Container(
      height: 200,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            MyProvider.server + path,
            fit: BoxFit.cover,
          )),
    ),
  );
}

Widget fileView(String path) {
  return Container(
    child: IconButton(
      icon: Icon(
        Icons.file_present_sharp,
        size: 70,
      ),
      onPressed: () async {
        print(basename(path));
        print(MyProvider.server + path);
        final file =
            await downloadFile(MyProvider.server + path, basename(path));
        if (file != null) {
          print('file open');
          OpenFile.open(file.path);
        }
      },
    ),
  );
}

Future<File?> downloadFile(String url, String? name) async {
  final appStorage = await getApplicationCacheDirectory();
  final file = File('${appStorage.path}/$name');

  try {
    final res = await Dio().get(url,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: Duration(seconds: 2)));
    final raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(res.data);
    await raf.close();
    return file;
  } catch (e) {
    return null;
  }
}
