import 'package:flutter/material.dart';
import 'package:ibanvault/core/routes/app_routes.dart';
import 'package:ibanvault/core/utils/AppColors.dart';
import 'package:ibanvault/providers/Iban_provider.dart';
import 'package:ibanvault/providers/auth_provider.dart';
import 'package:ibanvault/providers/friend_Ibans_provider.dart';
import 'package:ibanvault/services/authService.dart';
import 'package:provider/provider.dart';

void main() {
  
  runApp(const IbanVaultApp());
}

class IbanVaultApp extends StatefulWidget {
  const IbanVaultApp({super.key});

  @override
  State<IbanVaultApp> createState() => _IbanVaultAppState();
}

class _IbanVaultAppState extends State<IbanVaultApp> {
    late Future<bool> _loggedInFuture;
 @override
  void initState() {
    super.initState();
    _loggedInFuture = AuthService().isUserLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loggedInFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final loggedIn = snapshot.data ?? false;

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => IbansProvider()),
            ChangeNotifierProvider(create: (_) => FriendIbansProvider()),
                        ChangeNotifierProvider(create: (_) => AuthProvider()),

          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRoutes.onGenerateRoute,
            initialRoute: loggedIn ? '/home' : '/login',
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.black,
              primaryColor: Colors.white,
              colorScheme: ThemeData.dark().colorScheme.copyWith(
                primary: AppColors.blue,
              ),
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
      },
    );
  }
}
