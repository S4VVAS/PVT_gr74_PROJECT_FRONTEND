import 'package:flutter/material.dart';
import 'package:history_go/src/theme/style.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({this.text = "", this.actions, this.centerTitle = true})
      : super(
          title: Text(text, style: appTheme().textTheme.headline4),
          actions: actions,
          centerTitle: centerTitle,
        );
  final String text;
  final List<Widget> actions;
  final bool centerTitle;
}
