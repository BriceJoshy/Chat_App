import 'package:chat_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

//global object for accessing device screen size
late Size mq;

// statefull widget as we are dynamically changing it
class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(milliseconds: 500), () {}); // after half a second
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: mq.height * .3, // 30 % from top of screen
            width: mq.width *
                .50, // 50 % of the screen leaves 25 % on each side for space look left mq
            right: mq.width * .25, // 25% from left
            child: Image.asset('assets/icons/app_icon.png'),
          ),
          Positioned(
            bottom: mq.height * .25, // 15 % from top of screen
            width: mq.width,
            child: const Text(
              "Think. Feel. Chat 🐼", // windows and . for emoji keyboard
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .45, // 15 % from top of screen
            child: const CircularProgressIndicator(
              color: Colors.green,
              
            )
          ),
        ],
      ),
    );
  }
}
