import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';

class Chat_User_Card extends StatefulWidget {
  // to exit
  final ChatUser user;

  const Chat_User_Card({super.key, required this.user});

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
        child: ListTile(
          //user profile picture
          // leading: CircleAvatar(
          //   //backgroundImage: NetworkImage(widget.user.image),

          // ),
          leading: CachedNetworkImage(
            imageUrl: "http://via.placeholder.com/350x150",
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),

          //user name
          title: Text(widget.user.name),

          //last message
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
          ),

          //last message time
          trailing: const Text(
            "12:00 PM",
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
