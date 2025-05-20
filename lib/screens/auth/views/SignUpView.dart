import 'package:flutter/material.dart';
import 'package:ibanvault/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../data/models/user_model.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignupviewState();
}

class _SignupviewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  String? _selectedQuestion;
  final TextEditingController _securityAnswerController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sign Up Screen",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            "You can SignUp with your username and password.",
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    label: Text("User Name"),
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
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm Password is required';
                    } else if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _formKey.currentState?.validate();
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Security Question",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items:
                      [
                        "What is your favorite food?",
                        "What is your mother's maiden name?",
                        "What is the name of your first pet?",
                        "In what city were you born?",
                      ].map((question) {
                        return DropdownMenuItem<String>(
                          value: question,
                          child: Text(question),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedQuestion = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a security question';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _securityAnswerController,
                  decoration: InputDecoration(
                    labelText: "Your Answer",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide an answer';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final username = _usernameController.text.trim();
                            final password = _passwordController.text.trim();
                            final rememberQuestion =
                                _securityAnswerController.text.trim();
                            final user = User(
                              user_name: username,
                              password: password,
                              remeberQuestion: rememberQuestion,
                            );
                            await authProvider.registerUser(user);
                            if(authProvider.successMessage!=null){
                              _clearFormFields();
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
                          authProvider.isLoading
                              ? "Please wait a moment.."
                              : "Sign Up",
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
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _clearFormFields() {
    _usernameController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _securityAnswerController.clear();
    setState(() => _selectedQuestion = null);
  }
}
