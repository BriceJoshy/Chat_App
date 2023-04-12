// Creating a api class which has a static object for auth

import 'dart:developer';
import 'dart:io';

import 'package:chat_app/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  // for authentication
  // specifying the type of the static object
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing Firebase Storage
  static FirebaseStorage storage = FirebaseStorage.instance;

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

  // function for update profile picture of user
  // future as it can take a long time
  static Future<void> updateProfilePictre(File file) async {
    // calling a child for path
    // creating a path to the  folder profile_pictures to store the profile pictures
    // then storing images and that image name will be equal to user's uid to pervent storing duplicate images
    // first of all there should be a file that is uploaded from the user  to be accepted
    // passing a "file" from dart.io
    // after that getting an extension from that particular "file"\
    // so we use final ext (extenstion) and take the stuff after the '.' (dot part) and print it using log (for error checking)
    // this returns the file extention
    // now creating a reference "ref"
    final ext = file.path.split('.').last;
    log('Extension: $ext');
    //  storage.ref().child('profile_pictures/${user.uid}.');
    
    // storage file ref with path
    final ref = storage.ref().child('profile_pictures/${user.uid}.');
    // there will be no data so we nedd to push it out i.e simply passing that file and it will work
    // if we wnat setting the meta data
    // this function takes a lot of time i.e why "await" is used ,once this function is executed then execute some more code
    // i.e then provides the snapshot data

    // uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      // printing the bytes and /1000 for kb calculation
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });
    // updating the "me.image"
    // as it takes a lot of time "await" keyword is used
    // check image is final from "chat user page"
    // this is used to update image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore.collection('Users').doc(user.uid).update({
      'image': me.image, // "image" keyword from json file or check the firebase
    });
  }
}
