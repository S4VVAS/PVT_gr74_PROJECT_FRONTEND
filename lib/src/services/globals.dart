import 'package:history_go/src/models/user.dart';

class Globals {
  static final Globals _singleton = new Globals._internal();

  Globals._internal();

  static Globals get instance => _singleton;
  User user;
}