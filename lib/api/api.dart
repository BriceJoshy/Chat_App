// Creating a api class which has a static object for auth
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class APIs {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance; // specifying the type of the static object
  
  // for accessing cloud firestore databse
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  
}
