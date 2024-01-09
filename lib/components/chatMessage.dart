import 'package:eduflex/provider.dart';
import 'package:eduflex/service/schema/user.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Message extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isUser;
  const Message({super.key, required this.data, required this.isUser});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = widget.data['created'] != null
        ? DateTime.parse(widget.data['created'])
        : DateTime.now();
    String amPm = (dateTime.hour < 12) ? 'AM' : 'PM';
    String time = '${dateTime.hour}:${dateTime.minute} $amPm';
    return VisibilityDetector(
        key: Key(widget.data['id'].toString()),
        onVisibilityChanged: (info) async {
          User? user = await MyProvider.user();
          if (info.visibleFraction > 0.0) {
            if (widget.data['sender'] != user!.id &&
                widget.data['id'] != null) {
              await MyProvider.setChatSeen(widget.data['id']);
            }
          }
        },
        child: Container(
          alignment:
              widget.isUser ? Alignment.bottomRight : Alignment.bottomLeft,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.data['body']}',
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
                        child: widget.data['isSeen'] != null &&
                                widget.data['isSeen']
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
        ));
  }
}
