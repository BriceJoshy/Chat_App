import 'package:chat_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';


import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  _initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chatzon .',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            elevation: 1,
            centerTitle: true,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 19),
          ),
        ),
        home: const splash_screen());
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // now we need to call this function in main
}
