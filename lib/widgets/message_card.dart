import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/api.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';

import '../helper/my_date_util.dart';
import '../screens/splash_screen.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromid
        ? _greenMessage()
        : _blueMessage();
  }

  // sender or another user message
  Widget _blueMessage() {
    // update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      log('message read updated');
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // message content
        // why flexible = expanded uses max space while flexible only uses the needed space
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.lightBlue),
                color: const Color.fromARGB(255, 211, 241, 247),
                // for curvey edges except bottom left
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(30))),
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * 0.03
                : mq.width * 0.04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.height * 0.02, vertical: mq.height * 0.01),
            child: widget.message.type == Type.text
                ?
                // show text
                Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                // show image
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),

        Padding(
          padding: EdgeInsets.only(right: mq.width * 0.04),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          ),
        )
      ],
    );
  }

  // our or user message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // for adding some space
            SizedBox(width: mq.width * 0.04),

            // double tick blue icon for message read
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
              ),

            // for adding some space
            SizedBox(width: mq.width * 0.02),
            // read time
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ],
        ),
        // message content
        // why flexible = expanded uses max space while flexible only uses the needed space
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.lightGreen),
                color: Colors.green.shade100,
                // for curvey edges except bottom left
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * 0.03
                : mq.width * 0.04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.height * 0.02, vertical: mq.height * 0.01),
            child: widget.message.type == Type.text
                ?
                // show text
                Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                // show image
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.image,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
