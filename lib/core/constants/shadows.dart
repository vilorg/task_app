import 'package:flutter/material.dart';

class AppShadows {
  static const List<BoxShadow> appBarShadow = [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black12,
      blurRadius: 5,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black26,
      blurRadius: 10,
      offset: Offset(0, 1),
    ),
  ];

  static List<BoxShadow> tileShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(.06),
      blurRadius: 2,
    ),
    BoxShadow(
      color: Colors.black.withOpacity(.12),
      blurRadius: 2,
      offset: const Offset(0, 2),
    ),
  ];
}
