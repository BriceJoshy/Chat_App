import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  // not final as there is chance that the list is initialized many times
  // for storing all users
  List<ChatUser> _list = [];

  // for storing searched users
  // final cuz it is only initiazed once
  // creating a bool telling if search is on or not
  final List<ChatUser> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  // inside home screen i want to call this function so overridding the init state
  // because this is the first method when this(user) is called when screen is loaded
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    // for setting user staus to active in the firebase
    APIs.updateActiveStatus(true);
    // for active or not
    // setMessageHandler function in lifecycle
    // for updating the active status of the user in the lifecycle events
    // remume - give the active or online condition
    // pause - gives the inactive or offlinr condition
    SystemChannels.lifecycle.setMessageHandler((message) {
      log('Message: $message');
      // checking the message if it contains 'pause' then update the active status
      // if the user is not logged in then
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // closing the keyboard when tapping other places
      onTap: () => FocusScope.of(context).unfocus(),
      // dont close the app when the back is pressed in search state
      // if search is on and back button is pressed then close the search
      // or else simply close current screen on back click
      // will pop is only applicable in the current screen
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          //appbar
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.home,
                )),
            title: _isSearching
                ? TextField(
                    decoration: const InputDecoration(
                      //setting the border to null
                      border: InputBorder.none,
                      // giving the hint to the user for easy usability
                      hintText: 'Name, Email, ....',
                    ),
                    style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                    onChanged: (val) {
                      // search logic implementation
                      _searchList.clear();

                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            (i.email
                                .toLowerCase()
                                .contains(val.toLowerCase()))) {
                          _searchList.add(i);
                          setState(() {
                            _searchList;
                          });
                        }
                      }
                    },
                    // by default a curser should come ie why the auto focus is used
                    autofocus: true,
                  )
                : const Text('Chatzon .'),
            actions: [
              //search icon
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  // if it is searching changing the icon using a ternary operator
                  // the icon changes in different stages/status
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search)),
              //more icon
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => profile_screen(user: APIs.me)));
                  },
                  icon: const Icon(Icons.more_vert))
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
            stream: APIs.getAllUsers(),
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
                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];

                  if (_list.isNotEmpty) {
                    return ListView.builder(
                      itemCount:
                          _isSearching ? _searchList.length : _list.length,
                      padding: EdgeInsets.only(top: mq.height * .01),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        // returning the chat user card
                        return Chat_User_Card(
                            user: _isSearching
                                ? _searchList[index]
                                : _list[index]);
                      },
                    );
                  } else {
                    return const Center(
                        child: Text(
                      'No Connection Found',
                      style: TextStyle(fontSize: 20),
                    ));
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
