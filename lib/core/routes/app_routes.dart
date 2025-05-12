import 'package:flutter/material.dart';

import '../../screens/auth/views/authPage.dart';
import '../../screens/home/home_page.dart';

class AppRoutes {
  static Route onGenerateRoute(RouteSettings settings) {
    switch(settings.name){
      case '/':
      return MaterialPageRoute(builder: (context) => HomePage());
      case '/login':
      return MaterialPageRoute(builder: (context)=> LoginScreen());
      default :
      return MaterialPageRoute(builder: (context) => HomePage());

    }
  }
}