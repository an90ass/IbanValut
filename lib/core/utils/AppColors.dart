import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1E5B8A);
  static const Color secondary = Color(0xFFB0C4DE);
  static const Color background = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color danger = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
  static Color? blue = Colors.blue[800];
  static Color? grey = const Color.fromARGB(255, 203, 201, 201);
  // Define this in your AppColors class or constants file
  static const Gradient gradientBackground = LinearGradient(
    colors: [Color(0xFF1C1F26), Color(0xFF2F3542)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
