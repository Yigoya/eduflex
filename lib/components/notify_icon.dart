import 'dart:async';

import 'package:eduflex/pages/notification.dart';
import 'package:eduflex/provider.dart';
import 'package:flutter/material.dart';

class NotifyIcon extends StatefulWidget {
  const NotifyIcon({super.key});

  @override
  State<NotifyIcon> createState() => _NotifyIconState();
}

class _NotifyIconState extends State<NotifyIcon> {
  late StreamController<List<dynamic>> _streamController;
  late Stream<List<dynamic>> _stream;
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    getFriend();
  }

  void getFriend() async {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      try {
        List<dynamic> startedChat = await MyProvider.getNotification();
        _streamController.add(startedChat);
      } catch (e) {
        print('Error: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Stack(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationPage()));
                  },
                  icon: Icon(
                    Icons.notifications,
                    size: 30,
                  )),
              Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 17,
                    height: 17,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.red,
                    ),
                    child: Text(
                      '${snapshot.data!.length}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ))
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Expanded(child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _streamController.close();
    super.dispose();
  }
}
