import 'package:flutter/material.dart';
import 'package:ibanvault/core/routes/app_routes.dart';
import 'package:ibanvault/providers/addIban_provider.dart';
import 'package:ibanvault/providers/fetchIbans_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const IbanVaultApp());
}

class IbanVaultApp extends StatelessWidget {
  const IbanVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
         ChangeNotifierProvider(create: (_) => AddIbanProvider()),
                  ChangeNotifierProvider(create: (_) => FetchibansProvider()),

      ],
      child:  MaterialApp(
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
      ),
    );
  }
}
