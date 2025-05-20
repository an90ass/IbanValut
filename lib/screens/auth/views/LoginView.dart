import 'package:flutter/material.dart';
import 'package:ibanvault/core/routes/route_names.dart';
import 'package:ibanvault/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login Screen",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "You can login with your username and password.",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),

              Divider(height: 32),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController, 
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                            
                          },
                        ),
                      ),
                      validator: (value) {
                        if(value ==null || value.length <6){
                          return "Password is required";
                        }
                      },
                    ),

                    SizedBox(height: 24),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {

                  
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async{
                            if (_formKey.currentState!.validate()) {
                              final username = _usernameController.text.trim();
                              final password = _passwordController.text.trim();
                              print("Login with $username and $password");
                              await authProvider.userLogin(username, password) ;
                            if(authProvider.successMessage!=null){
                                _clearFormFields();
                                Navigator.pushReplacementNamed(context, Routenames.home);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(authProvider.successMessage!,style: TextStyle(color: Colors.white),),
                                  backgroundColor: Colors.green,
                                ),
                              );
                          } else  {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(authProvider.errorMessage!,
                                  style: TextStyle(color: Colors.white),),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }  }
                          },
                          child: Text(
                          authProvider.isLoading ? "Please wait a moment":  "Login",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                      
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(60, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      );
                      }  ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
    void _clearFormFields() {
    _usernameController.clear();
    _passwordController.clear();
 
  }
}
