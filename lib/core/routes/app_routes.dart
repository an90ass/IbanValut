import 'package:flutter/material.dart';

import '../../screens/home/home_screen.dart';

class AppRoutes {
  static Route onGenerateRoute(RouteSettings settings) {
    switch(settings.name){
      case '/':
      return MaterialPageRoute(builder: (context) => HomeScreen());
      default :
      return MaterialPageRoute(builder: (context) => HomeScreen());

    }
  }
}