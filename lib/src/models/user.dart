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
    switch (level) {
      case 1:
        if (exp >= getExpRequiredToLvlUp(1)) {
          level++;
          exp - getExpRequiredToLvlUp(1);
          if(exp > getExpRequiredToLvlUp(2))
            increaseExp(0);
        }
          break;
      case 2:
        if (exp >= getExpRequiredToLvlUp(2)) {
          level++;
          exp - getExpRequiredToLvlUp(2);
          if(exp > getExpRequiredToLvlUp(3))
            increaseExp(0);
        }
        break;
      case 3:
        if (exp >= getExpRequiredToLvlUp(3)) {
          level++;
          exp - getExpRequiredToLvlUp(3);
          if(exp > getExpRequiredToLvlUp(4))
            increaseExp(0);
        }
        break;
      case 4:
        if (exp >= getExpRequiredToLvlUp(4)) {
          level++;
          exp - getExpRequiredToLvlUp(4);
          if(exp > getExpRequiredToLvlUp(5))
            increaseExp(0);
        }
        break;
      case 5:
        if (exp >= getExpRequiredToLvlUp(5)) {
          level++;
          exp - getExpRequiredToLvlUp(5);
          if(exp > getExpRequiredToLvlUp(6))
            increaseExp(0);
        }
        break;
      case 6:
        if (exp >= getExpRequiredToLvlUp(6)) {
          level++;
          exp - getExpRequiredToLvlUp(6);
          if(exp > getExpRequiredToLvlUp(7))
            increaseExp(0);
        }
        break;
      case 7:
        if (exp >= getExpRequiredToLvlUp(7)) {
          level++;
          exp - getExpRequiredToLvlUp(7);
          if(exp > getExpRequiredToLvlUp(8))
            increaseExp(0);
        }
        break;
      case 8:
        if (exp >= getExpRequiredToLvlUp(8)) {
          level++;
          exp - getExpRequiredToLvlUp(8);
          if(exp > getExpRequiredToLvlUp(9))
            increaseExp(0);
        }
        break;
      case 9:
        if (exp >= getExpRequiredToLvlUp(9)) {
          level++;
          exp - getExpRequiredToLvlUp(9);
        }
        break;
    }
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
