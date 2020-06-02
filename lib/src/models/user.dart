import 'dart:collection';

class User {
  String name;
  String id;
  String email;
  String imgUrl;
  int level;
  List<String> visited;
  int exp;

  User({this.name, this.id, this.email, this.imgUrl, this.level, this.visited, this.exp});

  User.fromData(Map<String, dynamic> data) {
    name = data['name'];
    id = data['id'];
    email = data['email'];
    imgUrl = data['imgUrl'];
    level = data['level'];
    if (data['visited'] != null) {
      visited = new List<String>();
      data['visited'].forEach((v) {
        visited.add(v);
      });
      exp = data['exp'];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'email': email,
      'imgUrl': imgUrl,
      'level': level,
      'visited': visited,
      'exp': exp,
    };
  }

  void increaseLevel() {
    exp += 1;
    switch (level) {
      case 1:
        if (exp >= 3) level++;
        break;
      case 2:
        if (exp >= 7) level++;
        break;
      case 3:
        if (exp >= 15) level++;
        break;
      case 4:
        if (exp >= 26) level++;
        break;
      case 5:
        if (exp >= 37) level++;
        break;
      case 6:
        if (exp >= 48) level++;
        break;
      case 7:
        if (exp >= 59) level++;
        break;
      case 8:
        if (exp >= 70) level++;
        break;
      case 9:
        if (exp >= 100) level++;
        break;
    }
  }

  @override
  String toString() {
    return "name: " + name + " id: " + id;
  }
}
