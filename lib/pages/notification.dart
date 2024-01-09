import 'dart:async';

import 'package:eduflex/components/item.dart';
import 'package:eduflex/pages/MyClassRoom.dart';
import 'package:eduflex/provider.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
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
    return Scaffold(
      appBar: AppBar(title: Text('notification')),
      body: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length == 0) {
              return Center(
                child: Text('you have no notification'),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, i) {
                  if (snapshot.data![i]['post'] != null) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyClassRoom(
                                    data: snapshot.data![i]['post']
                                        ['classroom'])));
                      },
                      child: classRoomPost(context, snapshot.data![i]['post']),
                    );
                  } else if (snapshot.data![i]['chat'] != null) {
                    return chatMessage(context, snapshot.data![i]['chat']);
                  } else {
                    return Container();
                  }
                });
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
