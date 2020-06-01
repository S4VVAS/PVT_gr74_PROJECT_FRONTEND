class User {
  String name;
  String id;
  String email;
  String imgUrl;
  int level;
  List<String> visited;

  User({this.name, this.id, this.email, this.imgUrl, this.level, this.visited});

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
    };
  }

  @override
  String toString() {
    return "name: " + name + " id: " + id;
  }
}
