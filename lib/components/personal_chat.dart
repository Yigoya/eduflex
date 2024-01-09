import 'dart:async';

import 'package:eduflex/components/chatListItem.dart';
import 'package:eduflex/provider.dart';
import 'package:flutter/material.dart';

class PersonalChat extends StatefulWidget {
  const PersonalChat({super.key});

  @override
  State<PersonalChat> createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  late StreamController<List<dynamic>> _streamController;
  late Stream<List<dynamic>> _stream;

  late Timer _timer;
  bool personalChat = true;
  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;

    getFriend();
  }

  void getFriend() async {
    // List<dynamic> startedChat = await MyProvider.getStartedChat();
    // setState(() {
    //   _startedChat = startedChat;
    // });
    _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      try {
        List<dynamic> startedChat = await MyProvider.getStartedChat();
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
            final _startedChat = snapshot.data;
            return Expanded(
              child: ListView.builder(
                  itemCount:
                      _startedChat!.length == 0 ? 1 : _startedChat!.length,
                  itemBuilder: (context, i) {
                    if (_startedChat!.length != 0) {
                      Map<String, dynamic> data =
                          _startedChat[i] as Map<String, dynamic>;
                      DateTime dateTime =
                          DateTime.parse(data['msg']['created']);
                      String amPm = (dateTime.hour < 12) ? 'AM' : 'PM';
                      String time = '${dateTime.hour}:${dateTime.minute} $amPm';
                      return ChatListItem(data: data);
                    } else {
                      return SizedBox(
                          height: 300,
                          child: Center(child: Text("you have no chat")));
                    }
                  }),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Expanded(child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  @override
  void dispose() {
    _timer.cancel();
    _streamController.close();
    super.dispose();
  }
}
