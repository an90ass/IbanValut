import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ibanvault/core/routes/route_names.dart';
import 'package:ibanvault/providers/auth_provider.dart';
import 'package:provider/provider.dart';

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

        appBar: CustomAppBar(is_auth_page: true,
        actions: [
          InkWell(
            onTap: ()async{
              await authProvider.logOut();
               ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Loged out successfuly",style: TextStyle(color: Colors.white),),
                                  backgroundColor: Colors.green,
                                ),
                              );
                                Navigator.pushReplacementNamed(context, Routenames.login);
            },
            child: Icon(Icons.logout,color: Colors.white,),
          )
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



class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Settings Page", style: TextStyle(fontSize: 20)),
    );
  }
}
