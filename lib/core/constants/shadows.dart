import 'package:flutter/material.dart';

class AppShadows {
  static const List<BoxShadow> appBarShadow = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, .1),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, .1),
      blurRadius: 5,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, .2),
      blurRadius: 10,
      offset: Offset(0, 1),
    ),
  ];

  static List<BoxShadow> tileShadow = [
    const BoxShadow(
      color: Color.fromRGBO(0, 0, 0, .06),
      blurRadius: 2,
    ),
    const BoxShadow(
      color: Color.fromRGBO(0, 0, 0, .12),
      blurRadius: 2,
      offset: Offset(0, 2),
    ),
  ];
}
