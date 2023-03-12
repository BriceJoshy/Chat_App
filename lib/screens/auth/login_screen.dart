import 'package:flutter/material.dart';

//global object for accessing device screen size
late Size mq;

// statefull widget as we are dynamically changing it
class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      //appbar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome to Chatzon .'),
      ),
      body: Stack(
        children: [
          Positioned(
            top: mq.height * .15, // 15 % from top of screen
            width: mq.width *
                .50, // 50 % of the screen leaves 25 % on each side for space look left mq
            left: mq.width * .25, // 25% from left
            child: Image.asset('assets/icons/app_icon.png'),
          ),
          Positioned(
            bottom: mq.height * .15, // 15 % from top of screen
            width: mq.width * .9, // 90 % of the screen
            left: mq.width * .05, // 10% as its a button
            height: mq.height * .065,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  // ignore: prefer_const_constructors
                  backgroundColor: Color.fromARGB(255, 188, 217, 154),
                  shape: const StadiumBorder(),
                  elevation: 1),
              onPressed: () {},
              icon: Image.asset('assets/icons/google.png',height: mq.height * .03,),
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(text: 'Sign in with '),
                    TextSpan(
                        text: 'Google',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
