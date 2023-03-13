import 'package:chat_app/screens/auth/login_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    Future.delayed(const Duration(seconds: 3), () {
      //exit fullscreen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors
              .transparent)); //need it to be transparent in both light&dark themes

      //navigate to home screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => login_screen()));
    }); // after one and half a second
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
                .80, // 50 % of the screen leaves 25 % on each side for space look left mq
            right: mq.width * .10, // 25% from left
            child: Image.asset(
              'assets/icons/app_logo.png',
              color: Colors.black,
              height: 200,
            ),
          ),
          Positioned(
              bottom: mq.height * .2,
              left: mq.width * .4, // 15 % from top of screen
              child: Image.asset(
                "assets/images/loading.gif",
                height: 50,
              )),
        ],
      ),
    );
  }
}
