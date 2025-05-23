import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ibanvault/core/routes/route_names.dart';
import 'package:ibanvault/l10n/app_localizations.dart';
import 'package:ibanvault/providers/auth_provider.dart';
import 'package:ibanvault/screens/settings/views/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../widgets.dart';
import '../addIban/view/addIban_screen.dart';
import 'view/home_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _pages = [
    const HomeContent(),
    AddIbanScreen(),
    const SettingsPage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,

       appBar: CustomAppBar(
  is_auth_page: true,
  actions: [
    IconButton(
      tooltip: AppLocalizations.of(context)!.logOutBtn,
      icon: const Icon(Icons.logout, color: Colors.white),
      onPressed: () async {
        await authProvider.logOut();
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            message: AppLocalizations.of(context)!.logedOut,
          ),
        );
        Navigator.pushReplacementNamed(context, Routenames.login);
      },
    ),
  ],
),

        body: _pages[_selectedIndex],
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  CurvedNavigationBar _buildBottomNavigationBar() {
    return CurvedNavigationBar(
      index: _selectedIndex,
      onTap: _onItemTapped,
      color: Color.fromARGB(255, 21, 26, 38),
      key: _bottomNavigationKey,

      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationDuration: Duration(milliseconds: 600),
      letIndexChange: (index) => true,

      items: const [
        Icon(Icons.home, size: 30),
        Icon(Icons.add, size: 30),
        Icon(Icons.compare_arrows, size: 30),
      ],
    );
  }
}
