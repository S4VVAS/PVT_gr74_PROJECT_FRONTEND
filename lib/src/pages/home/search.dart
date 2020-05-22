import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  final Color color = Colors.green;


  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: FlatButton(
          onPressed: () {
            Navigator.pushNamed(context, '/info');
          },
          child: Text(
            'Kaknästornet',
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }
}
