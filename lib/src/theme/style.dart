import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appTheme() {
  return ThemeData(
      primarySwatch: Colors.blue,
      primaryColorBrightness: Brightness.dark,
      accentColor: Colors.lightBlueAccent,
      buttonColor: Colors.lightBlueAccent,
      splashColor: Colors.blue[900],
      splashFactory: ThemeData().splashFactory,
      backgroundColor: Colors.grey[100],
      accentColorBrightness: Brightness.dark,
      typography: Typography.material2018(),     
      textTheme: TextTheme(
        headline4: GoogleFonts.sourceSansPro(color: Colors.white, fontSize: 28),
        headline5: GoogleFonts.sourceSansPro(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.w400),
        headline6: GoogleFonts.sourceSansPro(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
        subtitle1: GoogleFonts.roboto(
            fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
        subtitle2: GoogleFonts.roboto(
            fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
        bodyText2: GoogleFonts.roboto(
            fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
        bodyText1: GoogleFonts.roboto(
            fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
        button: GoogleFonts.roboto(
          color: Colors.white,
            fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.2),
        caption: GoogleFonts.roboto(
            fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
        overline: GoogleFonts.roboto(
            fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
      ));
}