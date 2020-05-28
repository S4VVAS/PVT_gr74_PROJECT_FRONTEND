import 'package:flutter/material.dart';

class TitleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'History ',
          style: Theme.of(context).textTheme.headline5.copyWith(
                color: Colors.orange,
                fontSize: 45,
                fontWeight: FontWeight.w600,
              ),
          children: [
            TextSpan(
              text: 'Go',
              style: Theme.of(context).textTheme.headline5.copyWith(
                  color: Colors.black,
                  fontSize: 45,
                  fontWeight: FontWeight.w900),
            ),
            TextSpan(
              text: '!',
              style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 45,
                  fontWeight: FontWeight.w900),
            ),
          ]),
    );
  }
}

class WhiteTitleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'History ',
          style: Theme.of(context).textTheme.headline5.copyWith(
                color: Colors.white,
                fontSize: 45,
                fontWeight: FontWeight.w600,
              ),
          children: [
            TextSpan(
              text: 'Go',
              style: Theme.of(context).textTheme.headline5.copyWith(
                    color: Colors.black,
                    fontSize: 45,
                    fontWeight: FontWeight.w900,
                  ),
            ),
            TextSpan(
              text: '!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 45,
                fontWeight: FontWeight.w900,
              ),
            ),
          ]),
    );
  }
}
