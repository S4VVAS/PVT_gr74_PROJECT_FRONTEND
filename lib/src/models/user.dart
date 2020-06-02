class User {
  String name;
  String id;
  String email;
  String imgUrl;
  int level;
  List<String> visited;
  int exp;
  String expCounter;

  User({this.name, this.id, this.email, this.imgUrl, this.level, this.visited, this.exp, this.expCounter});

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
      expCounter = data['expCounter'];
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
      'expCounter': expCounter,
    };
  }

  void increaseLevel() {
    exp += 1;
    switch (level) {
      case 1:
        if (exp >= 3) {
          level++;
          expCounter = '7';
        }
          break;
      case 2:
        if (exp >= 7) {
          level++;
          expCounter = '15';
        }
        break;
      case 3:
        if (exp >= 15) {
          level++;
          expCounter = '26';
        }
        break;
      case 4:
        if (exp >= 26) {
          level++;
          expCounter = '37';
        }
        break;
      case 5:
        if (exp >= 37) {
          level++;
          expCounter = '48';
        }
        break;
      case 6:
        if (exp >= 48) {
          level++;
          expCounter = '59';
        }
        break;
      case 7:
        if (exp >= 59) {
          level++;
          expCounter = '70';
        }
        break;
      case 8:
        if (exp >= 70) {
          level++;
          expCounter = '100';
        }
        break;
      case 9:
        if (exp >= 100) {
          level++;
          expCounter = 'MAX';
        }
        break;
    }
  }

  @override
  String toString() {
    return "name: " + name + " id: " + id;
  }
}
