import 'package:eduflex/components/UserProfile.dart';
import 'package:eduflex/provider.dart';
import 'package:eduflex/service/schema/user.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class GroupMessage extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isUser;
  const GroupMessage({super.key, required this.data, required this.isUser});

  @override
  State<GroupMessage> createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = widget.data['msg']['created'] != null
        ? DateTime.parse(widget.data['msg']['created'])
        : DateTime.now();
    String amPm = (dateTime.hour < 12) ? 'AM' : 'PM';
    String time =
        '${dateTime.hour}:${dateTime.minute < 10 ? '0${dateTime.minute}' : dateTime.minute} $amPm';
    return VisibilityDetector(
      key: Key(widget.data['msg']['id'].toString()),
      onVisibilityChanged: (info) async {
        User? user = await MyProvider.user();
        if (info.visibleFraction > 0.0) {
          if (widget.data['msg']['sender'] != user!.id &&
              widget.data['msg']['id'] != null) {
            await MyProvider.setChatSeen(widget.data['msg']['id']);
          }
        }
      },
      child: Container(
        alignment: widget.isUser ? Alignment.bottomRight : Alignment.bottomLeft,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft:
                  widget.isUser ? Radius.circular(20) : Radius.circular(0),
              bottomRight:
                  widget.isUser ? Radius.circular(0) : Radius.circular(20),
            ),
            color: widget.isUser
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColorLight,
          ),
          // padding: EdgeInsets.all(5),
          // margin: EdgeInsets.only(bottom: 10),
          // alignment:
          //     widget.isUser ? Alignment.bottomRight : Alignment.bottomLeft,
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(10),
          //     topRight: Radius.circular(10),
          //     bottomLeft:
          //         widget.isUser ? Radius.circular(10) : Radius.circular(0),
          //     bottomRight:
          //         widget.isUser ? Radius.circular(0) : Radius.circular(10),
          //   ),
          // ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              !widget.isUser
                  ? UserProfile(
                      data: widget.data['user'],
                      justIcon: true,
                    )
                  : Container(),
              Text(
                '${widget.data['msg']['body']}',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).primaryColorDark),
              ),
              SizedBox(
                width: 10,
              ),
              widget.isUser
                  ? Container(
                      child: widget.data['msg']['isSeen'] != null &&
                              widget.data['msg']['isSeen']
                          ? Stack(
                              children: [
                                Positioned(
                                    child: Icon(
                                  Icons.check,
                                  size: 16,
                                )),
                                Positioned(
                                    right: 3,
                                    child: Icon(
                                      Icons.check,
                                      size: 16,
                                    ))
                              ],
                            )
                          : Icon(
                              Icons.check,
                              size: 16,
                            ),
                    )
                  : Container(),
              Text(
                time,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                    color: Theme.of(context).primaryColorDark),
              )
            ],
          ),
        ),
      ),
    );
  }
}
