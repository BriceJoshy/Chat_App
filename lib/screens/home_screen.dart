import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// statefull widget as we are dynamically changing it
class home_screen extends StatefulWidget {
  const home_screen({super.key});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
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
    );
  }
}
