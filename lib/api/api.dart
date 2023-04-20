import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';

import '../models/chat_user.dart';
import '../models/message.dart';

class APIs {
  // the following are the objects made

  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // for storing self information
  static late ChatUser me;

  // to return current user
  static User get user => auth.currentUser!;

  // for accessing firebase messaging (push notifications)
  FirebaseMessaging fmessaging = FirebaseMessaging.instance;

  // for checking if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore.collection('Users').doc(user.uid).get()).exists;
  }

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

  // for getting current user info
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

  // for adding an user to my user when first message is send
  static Future<void> sendFirstMessage(
      ChatUser chatUser, String msg, Type type) async {
    await firestore
        .collection('Users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatUser, msg, type));
  }

  // for updating user information
  static Future<void> updateUserInfo() async {
    await firestore.collection('Users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
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

  // update online or last active status
  // future void i.e why no "return"
  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('Users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

// update online or last active stats of user
  // this is the uid of our current user
  // updates the isonline and lastactive stuff in firebase

  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('Users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  ///************** Chat Screen Related APIs **************

  // chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)

  // useful for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // for sending message

  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(
        toid: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromid: user.uid,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromid)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  // send chat image
  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    final ext = file.path.split('.').last;

    // storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    // uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      // printing the bytes and /1000 for kb calculation
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    // "image" keyword from json file or check the firebase
    // updating the image in firestore database
    // storing image url sent as a message
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }
}
