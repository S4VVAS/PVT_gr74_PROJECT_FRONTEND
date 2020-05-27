import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'History ',
          style: Theme.of(context).textTheme.headline5.copyWith(
              color: Colors.orange, fontSize: 40, fontWeight: FontWeight.w700),
          children: [
            TextSpan(
              text: 'Go',
              style: Theme.of(context).textTheme.headline5.copyWith(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.w900),
            ),
            TextSpan(
              text: '!',
              style: TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 40,
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
              fontSize: 40,
              fontWeight: FontWeight.w700,
              decorationColor: Colors.black,
              decorationThickness: 2),
          children: [
            TextSpan(
              text: 'Go',
              style: Theme.of(context).textTheme.headline5.copyWith(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.w900),
            ),
            TextSpan(
              text: '!',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w900),
            ),
          ]),
    );
  }
}
