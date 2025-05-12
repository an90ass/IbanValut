import 'package:flutter/material.dart';
import 'package:ibanvault/screens/auth/views/LoginView.dart';
import 'package:ibanvault/screens/auth/views/SignUpView.dart';

import '../../../widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: CustomAppBar(is_auth_page: true),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        _buildTopButtons(),
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            children: [_buildLoginPage(), _buildSignUpPage()],
          ),
        ),
      ],
    );
  }

  Widget _buildTopButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  return _goToPage(0);
                },
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _currentPage == 0 ? Colors.blue : Colors.grey[600],
              
                  minimumSize: Size(60, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
      
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  
                  backgroundColor:
                      _currentPage == 1 ? Colors.blue : Colors.grey[600],
              
                  minimumSize: Size(60, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    
                  ),
                ),
                onPressed: () {
                  return _goToPage(1);
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
    );
  }

  Widget _buildLoginPage() {
    return LoginView();
  }

  Widget _buildSignUpPage() {
    return SignUpView();
  }

  void _goToPage(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentPage = pageIndex;
    });
  }
}
