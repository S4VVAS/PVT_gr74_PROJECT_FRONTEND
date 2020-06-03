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

  void increaseExp(int ex) {
    exp += ex;
    if (exp >= getExpRequiredToLvlUp(level)) {
      increaseLevel();
      increaseExp(0);
    }
  }

  void increaseLevel() {
    exp -= getExpRequiredToLvlUp(level);
    level++;
  }

  static int getExpRequiredToLvlUp(int lvl){
    switch(lvl){
      case 1:
        return 3;
      case 2:
        return 7;
      case 3:
        return 10;
      case 4:
        return 15;
      case 5:
        return 25;
      case 6:
        return 30;
      case 7:
        return 35;
      case 8:
        return 40;
      case 9:
        return 50;
        default:
          return 0;
    }
  }

  @override
  String toString() {
    return "name: " + name + " id: " + id;
  }
}
