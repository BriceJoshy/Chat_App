import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgets/message_card.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';
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
  // list of messages
  // for showing all messages
  List<Message> _list = [];

  // creating a private variable text editing controller
  // for handling message text changes
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade50,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // i want to design the appbar the way i want
          // prevent limitations of appbar i.e flexible
          // returning the widget custom appbar
          flexibleSpace: _appBar(),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: APIs.getAllMessages(widget.user),
                // where are we taking the data from , initializing the firestore api
                // to have the right access any collection
                // made a collection in the name of users
                // query in snapshots so as to get data then we get bit by bit data
                // in side the stream builder we check a condition if()
                // if the snapshot has data that case only print that using log
                // and storing this in to a final variable 'data'
                // data can be null i.e why the '?' after data
                // shows all the possible docs
                // printing the data using log
                // using a in loop to check if any data is coming or not
                // stream: APIs.getAllUsers(),
                builder: (context, snapshot) {
                  // handling cases 1. user not found/found
                  switch (snapshot.connectionState) {
                    // if data is loading
                    //either waiting or none
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      // shows a circular indicator
                      return const Center(child: SizedBox());
                    // if some or all data is loaded then show it
                    case ConnectionState.active: // doing
                    case ConnectionState.done: // done
                      final data = snapshot.data?.docs;
                      // // using the list made above
                      // // this works like a for loop
                      // // taes one object at a time an picks it and provides it
                      // // convert Chatuser from json to the list
                      // // data can be null thats why the "data?" dont execute this code if data is null and return the empty list []
                      _list = data
                              ?.map((e) => Message.fromJson(e.data()))
                              .toList() ??
                          [];

                      if (_list.isNotEmpty) {
                        return ListView.builder(
                          itemCount: _list.length,
                          padding: EdgeInsets.only(top: mq.height * .01),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            // returning the chat user card
                            // current index of the message list
                            return MessageCard(message: _list[index]);
                          },
                        );
                      } else {
                        return const Center(
                          child: Text('Say Hii! 👋',
                              style: TextStyle(fontSize: 20)),
                        );
                      }
                  }
                },
              ),
            ),
            SizedBox(
              height: mq.height * 0.21,
            ),
            _chatInput()
          ],
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
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * 0.01, horizontal: mq.width * 0.025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  // emoji button
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.emoji_emotions_rounded,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),
                  // expanded makes it to use all screen space
                  Expanded(
                      child: TextField(
                    // setting he controller
                    controller: _textController,
                    // for multiline textfield dynamic change when more stuff is typed
                    keyboardType: TextInputType.multiline,
                    maxLines: null, // not telling the max lines
                    decoration: const InputDecoration(
                        hintText: 'Type Something',
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none),
                  )),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),
                  SizedBox(
                    width: mq.width * 0.02,
                  )
                ],
              ),
            ),
          ),

          // send message button
          MaterialButton(
            onPressed: () {
              // dont want to send blank messages
              if (_textController.text.isNotEmpty) {
                // passing user and message(_textController.text)
                APIs.sendMessage(widget.user, _textController.text,Type.text);
                // clearing while sending
                _textController.text = '';
              }
            },
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            minWidth: 0,
            child: const Icon(
              Icons.send_rounded,
              color: Colors.white,
              size: 28,
            ),
            color: Colors.green.shade500,
            shape: const CircleBorder(),
          )
        ],
      ),
    );
  }
}