import 'dart:developer';

import 'package:chat_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // fullscreen display
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // system chrome helps us to implement fullscreen for our app
  // for fullscreen mode edit the styles.xml in both values
  // now for fixed portrait  orientation only
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    _initializeFirebase();
    runApp(const MyApp());
  });
  // the funtion that sets the orientation actually return a future and we don't wnat the portriat
  // is already set before the application actually starts , this creates weird gliches so
  // after the full code is executed , there is a attibute for every future i.e "then"
  // after the function is executed then we want to execute some code and work it
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
  // creating a channel for the app
  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For showing Message Notifications',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
  );
  log('\n Notification Channel Result: $result');
}
