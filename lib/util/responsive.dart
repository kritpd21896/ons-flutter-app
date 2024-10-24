import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;

  Responsive(this.context);

  // Get the screen width
  double getWidth(double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }

  // Get the screen height
  double getHeight(double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }

  // Get the screen size
  Size get screenSize {
    return MediaQuery.of(context).size;
  }
}