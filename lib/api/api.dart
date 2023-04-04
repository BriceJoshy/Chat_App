// Creating a api class which has a static object for auth

import 'dart:developer';

import 'package:chat_app/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  // for authentication
  static FirebaseAuth auth =
      FirebaseAuth.instance; // specifying the type of the static object

  // for accessing cloud firestore databse
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for storing self info
  static late ChatUser me; // late because it initialized late

  static User get user => auth.currentUser!;

  // for checking if user exits or not?
  // do the write operation only if the user is new or else dont overwrite the existing data
  static Future<bool> userExits() async {
    return (await firestore
            .collection('Users')
            .doc(auth.currentUser!
                .uid) // using the uid from the gmail login from firestore as the document id
            .get())
        .exists;
  }

  // creating afunction to store the details of 'your' own account to show in profile screen
  // when the info of the user has come then we want to check if the info
  // has come properly or not ,
  // if info has come properly then store in some global object
  static Future<void> getSelfInfo() async {
    // using the uid from the gmail login from firestore as the document id
    await firestore.collection('Users').doc(auth.currentUser!.uid).get().then(
      (user) async {
        if (user.exists) {
          me = ChatUser.fromJson(user.data()!);
          // if user exits then, but we got the json data so we have to parse it
          log('My Data: ${user.data()}');
        } else {
          // create a new user
          // await because this funcion should wait for some time
          // getSelfInfo is like a loop
          await createUser().then((value) => getSelfInfo());
        }
      },
    );
  }

  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chaUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey I'm using Chatzon .",
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );

    // push this info above to the firebase to make document
    // using the uid from the gmail login from firestore as the document id
    return (await firestore
        .collection('Users')
        .doc(user.uid)
        .set(chaUser.toJson()));
  }

  // returning all chat users from firestore database
  // this return some snapshots so we don't need to put "APIs" again
  // its type is "put curser on the getAllUsers()"

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    // while loading users from collection adding a filter using where clause
    // ie load users except our own id
    return firestore
        .collection('Users')
        .where('id',
            isNotEqualTo:
                user.uid) // except our id load all other users from firebase
        .snapshots();
  }

  // for updating user information
  static Future<void> updateUserInfo() async {
    await firestore
        .collection('Users')
        .doc(user.uid)
        .update({'name': me.name, 'about': me.about});
  }
}
