import 'dart:math';

import 'package:chat_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'google_auth.dart';
import 'package:flutter/material.dart';

//global object for accessing device screen size
late Size mq;

// statefull widget as we are dynamically changing it
class login_screen extends StatefulWidget {
  login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    }); // after half a second
  }

  _handleGoogleBtnClick() {
    signInWithGoogle().then((user) {
      log('\nUser: ${user.user}' as num);
      log('\nUserAdditionalInfo: ${user.additionalUserInfo}' as num);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const home_screen()));
    });
  }

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
          AnimatedPositioned(
            top: mq.height * .2, // 15 % from top of screen
            width: mq.width *
                .80, // 50 % of the screen leaves 25 % on each side for space look left mq
            right:
                _isAnimate ? mq.width * .1 : -mq.width * .5, // 25% from left
            duration: const Duration(seconds: 1),
            child: Image.asset(
              'assets/icons/app_logo.png',
              color: Colors.black,
            ),
          ),
          Positioned(
            bottom: mq.height * .15, // 15 % from top of screen
            width: mq.width * .9, // 90 % of the screen
            left: mq.width * .05, // 10% as its a button
            height: mq.height * .065,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  // ignore: prefer_const_constructors
                  backgroundColor: Color.fromARGB(255, 223, 255, 187),
                  shape: const StadiumBorder(),
                  elevation: 2),
              onPressed: () {
                // push replacement cuz i dont want the user to go back to this screen after logging in
                _handleGoogleBtnClick();
              },
              icon: Image.asset(
                'assets/icons/google.png',
                height: mq.height * .03,
              ),
              label: RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                    TextSpan(text: 'Log in with '),
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

class UserCredential {}
