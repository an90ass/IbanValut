import 'package:flutter/material.dart';

import '../../screens/home/home_page.dart';

class AppRoutes {
  static Route onGenerateRoute(RouteSettings settings) {
    switch(settings.name){
      case '/':
      return MaterialPageRoute(builder: (context) => HomePage());
      default :
      return MaterialPageRoute(builder: (context) => HomePage());

    }
  }
}