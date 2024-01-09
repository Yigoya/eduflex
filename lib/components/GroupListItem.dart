import 'dart:async';

import 'package:eduflex/components/UserProfile.dart';
import 'package:eduflex/components/auth.dart';
import 'package:eduflex/components/groupchat.dart';
import 'package:eduflex/pages/GroupChatRoom.dart';
import 'package:eduflex/pages/chatHome.dart';
import 'package:eduflex/provider.dart';
import 'package:flutter/material.dart';

class GroupListItem extends StatefulWidget {
  final Map<String, dynamic> data;
  const GroupListItem({super.key, required this.data});

  @override
  State<GroupListItem> createState() => _GroupListItemState();
}

class _GroupListItemState extends State<GroupListItem> {
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
    // List<dynamic> startedChat = await MyProvider.getStartedChat();
    // setState(() {
    //   _startedChat = startedChat;
    // });
    // _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
    //   try {
    //     List<dynamic> startedChat =
    //         await MyProvider.getUnseen(widget.data['msg']['roomid']);
    //     _streamController.add(startedChat);
    //   } catch (e) {
    //     print('Error: $e');
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    // DateTime dateTime = DateTime.parse(widget.data['msg']['created']);
    // String amPm = (dateTime.hour < 12) ? 'AM' : 'PM';
    // String time = '${dateTime.hour}:${dateTime.minute} $amPm';
    return GestureDetector(
      onTap: () async {
        // _timer.cancel();

        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GroupChatScreen(
                      data: widget.data['group'],
                      roomid: widget.data['group']['idname'],
                    )));
        print("back from chat baby");
        setState(() {
          _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
            try {
              List<dynamic> startedChat = await MyProvider.getStartedChat();
              _streamController.add(startedChat);
            } catch (e) {
              print('Error: $e');
            }
          });
        });
      },
      child: Stack(children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border(
                  bottom: BorderSide(
                color: Theme.of(context).cardColor,
              ))),
          child: Row(
            children: [
              UserProfile(data: widget.data['group']),
            ],
          ),
        ),
        widget.data['msg'] != 0
            ? Positioned(
                left: 74,
                bottom: 16,
                child: Text(
                  '${widget.data['msg']['body']}',
                  style: TextStyle(color: Theme.of(context).cardColor),
                ),
              )
            : Container(),
        // Positioned(
        //     top: 20,
        //     right: 20,
        //     child: Text(
        //       time,
        //       style: TextStyle(color: Theme.of(context).primaryColorDark),
        //     )),
        // Positioned(
        //     top: 40,
        //     right: 20,
        //     child: StreamBuilder(
        //       stream: _stream,
        //       builder: (context, snapshot) {
        //         if (snapshot.hasData) {
        //           return snapshot.data!.length != 0
        //               ? Container(
        //                   width: 23,
        //                   height: 23,
        //                   decoration: BoxDecoration(
        //                     borderRadius: BorderRadius.circular(20),
        //                     color: Colors.red,
        //                   ),
        //                   child: Center(
        //                     child: Text(
        //                       '${snapshot.data!.length}',
        //                       textAlign: TextAlign.center,
        //                       style:
        //                           TextStyle(color: Colors.white, fontSize: 14),
        //                     ),
        //                   ),
        //                 )
        //               : Container();
        //         } else {
        //           return Container();
        //         }
        //       },
        //     )),
      ]),
    );
  }
}
