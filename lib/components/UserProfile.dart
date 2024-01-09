import 'package:eduflex/components/auth.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool justIcon;
  const UserProfile({super.key, required this.data, this.justIcon = false});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        // border: Border(
        //     bottom: BorderSide(
        //   color: Theme.of(context).cardColor,
        // ))
      ),
      child: Row(
        children: [
          userProfilepPic(context, widget.data['avatar'], widget.data['name'],
              widget.data['isOnline']),
          !widget.justIcon
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.data['name']}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
