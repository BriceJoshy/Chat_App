import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

import '../models/chat_user.dart';
import 'splash_screen.dart';

class ChatScreen extends StatefulWidget {
  // every chatscreen expects a user so we need to pass a user
  final ChatUser user;
  const ChatScreen({
    super.key,
    required this.user,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // i want to design the appbar the way i want
          // prevent limitations of appbar i.e flexible
          // returning the widget custom appbar
          flexibleSpace: _appBar(),
        ),
        body: Column(
          children: [_chatInput()],
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          // back button
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          // users pic
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .3),
            child: CachedNetworkImage(
              width: mq.height * .045,
              height: mq.height * .045,
              imageUrl: widget.user.image,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          // user name and last online in a column
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 2,
              ),
              const Text(
                "last Online 'dead'",
                style: TextStyle(
                  fontSize: 13.5,
                  color: Colors.black54,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Row(
      children: [
        Expanded(
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                // emoji button
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.emoji_emotions_rounded,
                    color: Colors.blueAccent,
                  ),
                ),
                // expanded makes it to use all screen space
                const Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                      hintText: 'Type Something',
                      hintStyle: TextStyle(color: Colors.blueAccent),
                      border: InputBorder.none),
                )),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.image,
                    color: Colors.blueAccent,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
