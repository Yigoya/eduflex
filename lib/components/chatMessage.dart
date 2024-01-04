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
      onVisibilityChanged: (info) {},
      child: Container(
        width: 200,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft:
                widget.isUser ? Radius.circular(10) : Radius.circular(0),
            bottomRight:
                widget.isUser ? Radius.circular(0) : Radius.circular(10),
          ),
          color: widget.isUser
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColorLight,
        ),
        child: Stack(children: [
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.only(bottom: 10),
            alignment:
                widget.isUser ? Alignment.bottomRight : Alignment.bottomLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft:
                    widget.isUser ? Radius.circular(10) : Radius.circular(0),
                bottomRight:
                    widget.isUser ? Radius.circular(0) : Radius.circular(10),
              ),
            ),
            child: Text(
              '${widget.data['body']}',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).primaryColorDark),
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: Text(
                time,
                style: TextStyle(
                    fontSize: 13, color: Theme.of(context).primaryColorDark),
              ))
        ]),
      ),
    );
  }
}
