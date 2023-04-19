import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/view_profile_screen.dart';
import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
        width: mq.width * 0.6,
        height: mq.height * 0.35,
        child: Stack(
          children: [
            Positioned(
              top: mq.height * .075,
              left: mq.width * 0.1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * .25),
                child: CachedNetworkImage(
                  width: mq.width * .5,
                  fit: BoxFit.cover,
                  imageUrl: user.image,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.person),
                ),
              ),
            ),
            Positioned(
              left: mq.width * 0.04,
              top: mq.height * 0.02,
              width: mq.width * 0.55,
              // if the user name is very big and overlaps the info button              width: mq.width * 0.55,
              child: Text(
                user.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Positioned(
              right: 0,
              top: mq.height * 0.006,
              child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ViewProfileScreen(user: user)));
                },
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(0),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
