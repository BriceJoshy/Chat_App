import 'dart:developer';
import 'dart:io';

import 'package:chat_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../api/api.dart';
import '../../helper/dialogs.dart';
import '../splash_screen.dart';

//login screen -- implements google sign in or sign up feature for app
class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();

    //for auto triggering animation
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _isAnimate = true);
    });
  }

  // handles google login button click
  _handleGoogleBtnClick() {
    //for showing progress bar
    Dialogs.showProgressBar(context);

    _signInWithGoogle().then((user) async {
      //for hiding progress bar
      Navigator.pop(context);

      if (user != null) {
        log('\nUser: ${user.user}');
        log('\nUserAdditionalInfo: ${user.additionalUserInfo}');

        if (await APIs.userExits()) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const home_screen()));
        } else {
          await APIs.createUser().then((value) => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const home_screen())));
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log('\n_signInWithGoogle: $e');
      Dialogs.showErrorSnackbar(
          context, 'Oh snap!!', 'Something Went Wrong (Check Internet!)');
      return null;
    }
  }

  //sign out function
  // _signOut() async {
  //   await FirebaseAuth.instance.signOut();
  //   await GoogleSignIn().signOut();
  // }

  @override
  Widget build(BuildContext context) {
    //initializing media query (for getting device screen size)
    // mq = MediaQuery.of(context).size;

    return Scaffold(
      //app bar
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: const Text('Welcome to ChatZon. '),
      //   elevation: 0,
      // ),

      //body
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/login_bg.jpeg"),
              fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            //app logo
            AnimatedPositioned(
              top: mq.height * .25,
              right: _isAnimate ? mq.width * .1 : -mq.width * .5,
              width: mq.width * .8,
              duration: const Duration(seconds: 1),
              child: Image.asset(
                'assets/icons/app_title.png',
                color: Colors.black,
              ),
            ),

            //google login button
            Positioned(
              bottom: mq.height * .25,
              left: mq.width * .15,
              width: mq.width * .7,
              height: mq.height * .06,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 1),
                onPressed: () {
                  _handleGoogleBtnClick();
                },

                //google icon
                icon: Image.asset('assets/icons/google.png',
                    height: mq.height * .03),

                //login with google label
                label: RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    children: [
                      TextSpan(text: 'Login with '),
                      TextSpan(
                          text: 'Google',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: mq.height * 0.24,
              left:  mq.width * 0.5,
              child: Image.asset(
                'assets/images/cat_loading.gif',
                height: mq.height * 0.12,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
