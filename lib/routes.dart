import 'package:flutter/material.dart';
import 'package:history_go/src/pages/pages.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/welcome': (context) => WelcomePage(),
  '/login': (context) => LoginPage(),
  '/signup': (context) => SignUpPage(),
  '/home': (context) => HomePage(),
  '/map': (context) => MapPage(),
  '/info': (context) => InfoPage(),
  '/missions': (context) => MissionsPage(),
  '/permissions': (context) => PermissionPage(),
  '/profile': (context) => ProfilePage(),
  '/search': (context) => SearchPage(),
};

Route unknownRoute(RouteSettings settings) {
  return new PageRouteBuilder(pageBuilder: (BuildContext context,
      Animation<double> animation, Animation<double> secondaryAnimation) {
    return new Scaffold(
      body: Center(
        child: Text('Route for ${settings.name} is not defined'),
      ),
    );
  });
}
