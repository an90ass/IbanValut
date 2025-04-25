import 'package:flutter/material.dart';
import 'package:ibanvault/core/routes/app_routes.dart';

void main() {
  runApp(const IbanVaultApp());
}

class IbanVaultApp extends StatelessWidget {
  const IbanVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRoutes.onGenerateRoute,
      initialRoute: '/',

      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.white,
        textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
    );
  }
}
