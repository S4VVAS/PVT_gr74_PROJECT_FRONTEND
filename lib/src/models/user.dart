import 'package:flutter/material.dart';
import 'package:history_go/src/models/place.dart';

class User {
  final String name;
  final String id;
  final String email;
  final String imgUrl;
  //final Image img;
  int level;
  List<Place> visited;

  User({this.name, this.id, this.email, this.imgUrl, this.level, this.visited});

  User.fromData(Map<String, dynamic> data)
      : name = data['name'],
        id = data['id'],
        email = data['email'],
        imgUrl = data['imgUrl'],
        //img = data['img'],
        level = data['level'],
        visited = data['visited'];

  Map<String, dynamic> toJson() {
    return {
      'name' : name,
      'id': id,
      'email': email,
      'imgUrl': imgUrl,
      //'img': img,
      'level': level,
      'visited': visited,
    };
  }

  @override
  String toString() {
    return "name: " + name;
  }
}
