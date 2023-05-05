import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/api/api.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../helper/dialogs.dart';
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
    // setting commen inkwell for bottom sheet
    // the child of inkwell is independant on the condition
    // creating a variable bool isMe
    // want to implement common long press for both
    bool isMe = APIs.user.uid == widget.message.fromid;
    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _greenMessage() : _blueMessage(),
    );
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

// bottom sheet for modifying message details
// expecting a variable
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                  vertical: mq.height * 0.015,
                  horizontal: mq.width * 0.4,
                ),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),

              // copy option only for text message
              // should not come for image message
              widget.message.type == Type.text
                  ? _OptionItem(
                      icon: const Icon(
                        Icons.copy_all_rounded,
                        color: Colors.blue,
                        size: 26,
                      ),
                      name: 'Copy Text',
                      onTap: () async {
                        // await as it will take some time
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) => // for hiding bottom sheet
                                Navigator.pop(context));

                        Dialogs.showSuccesSnackbar(
                            context, 'Copied!', 'Text copied to clipbord');
                      })
                  : _OptionItem(
                      icon: const Icon(Icons.download_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Save Image',
                      onTap: () async {
                        try {
                          log('Image Url: ${widget.message.msg}');
                          await GallerySaver.saveImage(widget.message.msg,
                                  albumName: 'We Chat')
                              .then((success) {
                            //for hiding bottom sheet
                            Navigator.pop(context);
                            if (success != null && success) {
                              Dialogs.showSuccesSnackbar(
                                  context,
                                  'Image Successfully Saved!',
                                  'Saved to gallery');
                            }
                          });
                        } catch (e) {
                          log('ErrorWhileSavingImg: $e');
                        }
                      }),

              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: mq.width * 0.04,
                  indent: mq.width * 0.04,
                ),

              // only edit if message is text
              // only edit if my own message
              if (widget.message.type == Type.text && isMe)
                // edit option
                _OptionItem(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                      size: 26,
                    ),
                    name: 'Edit Message',
                    onTap: () {}),

              // only delete if message is text
              // only delete if my own message
              if (isMe)
                // delete option
                _OptionItem(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 26,
                    ),
                    name: 'Delete Message',
                    onTap: () async {
                      await APIs.deleteMessage(widget.message).then((value) {
                        // hiding the bottom sheet
                        Navigator.pop(context);
                      });
                    }),

              Divider(
                color: Colors.black54,
                endIndent: mq.width * 0.04,
                indent: mq.width * 0.04,
              ),

              // sent time
              _OptionItem(
                  icon: const Icon(
                    Icons.remove_red_eye_rounded,
                    color: Colors.blue,
                  ),
                  name: 'Send At:${MyDateUtil.getMessageTime(
                    context: context,
                    time: widget.message.sent,
                  )}',
                  onTap: () {}),

              // read time
              _OptionItem(
                  icon: const Icon(
                    Icons.remove_red_eye_rounded,
                    color: Colors.green,
                  ),
                  name: widget.message.read.isEmpty
                      ? 'Read At: Not seen yet'
                      : 'Read at:${MyDateUtil.getFormattedTime(
                          context: context,
                          time: widget.message.read,
                        )}',
                  onTap: () {})
            ],
          );
        });
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  // funtion is passed for ontap
  final VoidCallback onTap;
  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
            left: mq.width * 0.05,
            top: mq.height * 0.015,
            bottom: mq.height * 0.015),
        child: Row(
          // spaces is used for seperation btw them
          children: [
            icon,
            Flexible(
                child: Text(
              '     $name',
              style: const TextStyle(
                  fontSize: 15, color: Colors.black54, letterSpacing: 0.5),
            ))
          ],
        ),
      ),
    );
  }
}
