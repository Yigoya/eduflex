import 'package:eduflex/components/auth.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  final Map<String, dynamic> data;
  const UserProfile({super.key, required this.data});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          userProfilepPic(context, widget.data['avatar'], widget.data['name'],
              widget.data['isOnline']),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.data['name']}',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
