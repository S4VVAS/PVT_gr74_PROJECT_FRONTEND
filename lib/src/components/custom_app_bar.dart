import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({this.text = "", this.actions, this.centerTitle = true, this.backButton = false});
  final String text;
  final double height = AppBar().preferredSize.height;
  final List<Widget> actions;
  final bool centerTitle;
  final bool backButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(text, style: Theme.of(context).textTheme.headline4),
      actions: actions,
      centerTitle: centerTitle,
      leading: backButton? new BackButton() : null,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
