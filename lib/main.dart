import 'package:flutter/material.dart';
import 'package:history_go/routes.dart';
import 'package:history_go/src/theme/style.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //This is the root of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'History Go!',
      theme: appTheme(),
      initialRoute: '/welcome',
      routes: routes,
      onUnknownRoute: (settings) => unknownRoute(settings),
    );
  }
}
