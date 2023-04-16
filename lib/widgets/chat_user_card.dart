import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/api.dart';
import 'package:chat_app/helper/my_date_util.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';
import '../screens/chat_screen.dart';
import '../screens/splash_screen.dart';

class Chat_User_Card extends StatefulWidget {
  // to exit
  final ChatUser user;

  const Chat_User_Card({super.key, required this.user});

  @override
  State<Chat_User_Card> createState() => _Chat_User_CardState();
}

class _Chat_User_CardState extends State<Chat_User_Card> {
  // last message info (if null --> no messsage)
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      color: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 0.5,
      child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  user: widget.user,
                ),
              ),
            );
          },
          child: StreamBuilder(
            stream: APIs.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty) _message = list[0];

              return ListTile(
                //user profile picture
                // leading: CircleAvatar(
                //   //backgroundImage: NetworkImage(widget.user.image),

                // ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .3),
                  child: CachedNetworkImage(
                    width: mq.height * .055,
                    height: mq.height * .055,
                    imageUrl: widget.user.image,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),

                //user name
                title: Text(widget.user.name),

                //last message
                subtitle: Text(
                  _message != null ? _message!.msg : widget.user.about,
                  maxLines: 1,
                ),

                //last message time
                trailing: _message == null
                    ? null // show nothing when no message is send
                    : _message!.read.isEmpty &&
                            _message!.fromid != APIs.user.uid
                        // show for unread message
                        ? Container(
                            width: 15,
                            height: 15,
                            decoration: const BoxDecoration(
                                color: Color(0xff00BD00),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          )
                        // message sent time
                        : Text(
                            MyDateUtil.getLastMessageTime(
                                context: context, time: _message!.sent),
                            style: const TextStyle(color: Colors.black54),
                          ),
              );
            },
          )),
    );
  }
}
