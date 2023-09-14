import 'package:flutter/material.dart';

class Constants {
  LinearGradient bgGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      tileMode: TileMode.repeated,
      colors: [Color(0xff8EC5FC), Color(0xffE0C3FC)]);
  LinearGradient appbarGradient = const LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      tileMode: TileMode.repeated,
      colors: [Color(0xff8EC5FC), Color(0xffE0C3FC)]);
  Color addButtonColor = const Color(0xffF8F7FF);
  Color buttonIconColor = const Color(0xffF2BEFC);
  Color checkColor = const Color(0xffCA9CE1);
  TextStyle textStyle = const TextStyle(
    color: Color(0xffF8F7FF),
    fontSize: 24,
  );
  TextStyle timeStyle = const TextStyle(
    color: Color(0xffF8F7FF),
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  TextStyle bottomLabelStyle = const TextStyle(
    color: Color(0xffF8F7FF),
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

}

enum ListType {
  allTasks,
  completed,
  active,
}

class AreaSizes {
  double appbarMultip = 0.12;
  double bodyMultip = 0.88;
}
