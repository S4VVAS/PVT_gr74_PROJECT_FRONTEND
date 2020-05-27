import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:history_go/src/models/user.dart';
import 'package:history_go/src/services/globals.dart';

class FirestoreService {
  final CollectionReference _usersCollectionReference =
  Firestore.instance.collection('users');

  Future<void> createUser(User user) async {
    try {
      await _usersCollectionReference.document(user.id).setData(user.toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future<void> updateUser(User user) async {
    try {
      print("userid: " + user.id);
      await _usersCollectionReference.document(user.id).setData(user.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<User> getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.document(uid).get();
      print('userdata: ' + userData.toString());
      return User.fromData(userData.data);
    } catch (e) {
      print(e);
      return null;
    }
  }
}