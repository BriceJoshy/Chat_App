// Creating a api class which has a static object for auth
import 'package:chat_app/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  // for authentication
  static FirebaseAuth auth =
      FirebaseAuth.instance; // specifying the type of the static object

  // for accessing cloud firestore databse
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

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
}
