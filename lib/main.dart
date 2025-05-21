import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ibanvault/core/routes/app_routes.dart';
import 'package:ibanvault/core/utils/AppColors.dart';
import 'package:ibanvault/l10n/L10n.dart';
import 'package:ibanvault/l10n/app_localizations.dart';
import 'package:ibanvault/providers/Iban_provider.dart';
import 'package:ibanvault/providers/auth_provider.dart';
import 'package:ibanvault/providers/friend_Ibans_provider.dart';
import 'package:ibanvault/providers/language_provider.dart';
import 'package:ibanvault/services/authService.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => IbansProvider()),
        ChangeNotifierProvider(create: (_) => FriendIbansProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
 ChangeNotifierProvider(create: (_) => LanguageProvider()),      ],
      child: const IbanVaultApp(),
    ),
  );
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
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        final loggedIn = snapshot.data ?? false;

        return Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
            print(languageProvider.locale);
            return MaterialApp(
                          debugShowCheckedModeBanner: false,

              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              locale: languageProvider.locale,
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
            );
          },
        );
      },
    );
  }
}
