import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double screenWidth(double val) {
    return MediaQuery.sizeOf(this).width * val;
  }

  double screenHeight(double val) {
    return MediaQuery.sizeOf(this).height * val;
  }

  ThemeData get theme => Theme.of(this);

  ColorScheme getColorSheme() {
    return Theme.of(this).colorScheme;
  }

  SizedBox verticalSpace(double value) {
    return SizedBox(height: screenHeight(value));
  }

  SizedBox horizontalSpace(double value) {
    return SizedBox(width: screenWidth(value));
  }
}
