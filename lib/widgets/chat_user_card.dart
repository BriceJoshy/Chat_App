import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';

class Chat_User_Card extends StatefulWidget {
  const Chat_User_Card({super.key});

  @override
  State<Chat_User_Card> createState() => _Chat_User_CardState();
}

class _Chat_User_CardState extends State<Chat_User_Card> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0.5,
      child: InkWell(
        onTap: () {},
        child: const ListTile(
          //user profile picture
          leading: CircleAvatar(
            child: Icon(CupertinoIcons.person),
          ),

          //user name
          title: Text('Demo User'),

          //last message
          subtitle: Text(
            'Last Message',
            maxLines: 1,
          ),

          //last message time
          trailing: Text(
            "12:00 PM",
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
