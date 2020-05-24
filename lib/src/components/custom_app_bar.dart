import 'package:flutter/material.dart';
import 'package:history_go/src/theme/style.dart';

class CustomAppBar extends AppBar {
  //Ändra till statelesswidget och returnera egen appbar istället.
  CustomAppBar({this.text = "", this.actions, this.centerTitle = true, this.backButton = false})
      : super(
          title: Text(text, style: appTheme().textTheme.headline4),
          actions: actions,
          centerTitle: centerTitle,
          leading: backButton ? BackButton() : null,
        );
  final String text;
  final List<Widget> actions;
  final bool centerTitle;
  final bool backButton;
}
