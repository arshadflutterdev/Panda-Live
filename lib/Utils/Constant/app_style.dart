import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  static TextStyle logo = GoogleFonts.oswald(
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );
  static TextStyle btext = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static TextStyle tagline = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
  );
  static TextStyle halfblacktext = TextStyle(
    fontSize: 16,
    color: Colors.black38,
  );
  static TextStyle arabictext = GoogleFonts.amiri(fontSize: 16);
}
