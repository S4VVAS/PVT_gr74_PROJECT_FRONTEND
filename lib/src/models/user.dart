import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:history_go/src/models/place.dart';

class User {
  String name;
  String id;
  String email;
  String imgUrl;
  //final Image img;
  int level;
  List<GeoPoint> visited;

  User({this.name, this.id, this.email, this.imgUrl, this.level, this.visited});

  User.fromData(Map<String, dynamic> data) {
    name = data['name'];
    id = data['id'];
    email = data['email'];
    imgUrl = data['imgUrl'];
    //img = data['img'],
    level = data['level'];
    if (data['visited'] != null) {
      visited = new List<GeoPoint>();
      data['visited'].forEach((v) {
        visited.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
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
