import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:history_go/src/models/user.dart';
import 'package:history_go/src/services/globals.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
  Firestore.instance.collection('users');

  Future<void> createUser(FirebaseUser user) async {
    User _user = User(
            name: user.email,
            id: user.uid,
            email: user.email,
            imgUrl: user.photoUrl,
            level: 1,
            exp: 0,
            visited: new List<String>());
    updateUser(_user);
  }

  void updateUser(User user) {
    try {
      print("userid: " + user.id);
      _usersCollectionReference.document(user.id).setData(user.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<User> getUser(String uid) async {
    try {
      print(uid);
      var userData = await _usersCollectionReference.document(uid).get();
      print('userdata: ' + userData.data.toString());
      if (userData.exists)
        return User.fromData(userData.data);
      else 
        return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}