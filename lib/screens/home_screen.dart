import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/api.dart';
import '../widgets/chat_user_card.dart';
import 'splash_screen.dart';

// statefull widget as we are dynamically changing it
class home_screen extends StatefulWidget {
  const home_screen({super.key});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  List<ChatUser> list =
      []; // not final as there is chance that the list is initialized many times

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.home,
            )),
        title: const Text('Chatzon .'),
        actions: [
          //search icon
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
          //more icon
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),

      //floating action button
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10),
        child: FloatingActionButton(
            onPressed: () {}, child: const Icon(Icons.add_comment_rounded)),
      ),

      // builds list item for every user
      body: StreamBuilder(
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
        stream: APIs.firestore.collection('Users').snapshots(),
        builder: (context, snapshot) {
          // handling cases 1. user not found/found
          switch (snapshot.connectionState) {
            // if data is loading
            //either waiting or none
            case ConnectionState.waiting:
            case ConnectionState.none:
              // shows a circular indicator
              return const Center(child: CircularProgressIndicator());
            // if some or all data is loaded then show it
            case ConnectionState.active: // doing
            case ConnectionState.done: // done

              final data = snapshot.data?.docs;
              // using the list made above
              // this works like a for loop
              // taes one object at a time an picks it and provides it
              // convert Chatuser from json to the list
              // data can be null thats why the "data?" dont execute this code if data is null and return the empty list []
              list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              if (list.isNotEmpty) {
                return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.only(top: mq.height * .01),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    // returning the chat user card
                    return Chat_User_Card(user: list[index]);
                  },
                );
              }
              else {
                return const Center(child: Text('No Connection Found',style: TextStyle(fontSize: 20),));
              }
          }
        },
      ),
    );
  }
}
