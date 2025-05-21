import 'package:flutter/material.dart';
import 'package:ibanvault/l10n/app_localizations.dart';
import 'package:ibanvault/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.signUpScreen,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              AppLocalizations.of(context)!.signUpSubtitle,
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
                      label: Text(AppLocalizations.of(context)!.username),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.usernameRequired;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.password,
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
                        return AppLocalizations.of(context)!.passwordRequired;
                      } else if (value.length < 6) {
                        return AppLocalizations.of(context)!.passwordTooShort;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.confirmPassword,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(
                          context,
                        )!.confirmPasswordRequired;
                      } else if (value != _passwordController.text) {
                        return AppLocalizations.of(
                          context,
                        )!.passwordsDoNotMatch;
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
                      labelText: AppLocalizations.of(context)!.securityQuestion,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items:
                        [
                          AppLocalizations.of(context)!.questionFavFood,
                          AppLocalizations.of(context)!.questionMotherMaiden,
                          AppLocalizations.of(context)!.questionFirstPet,
                          AppLocalizations.of(context)!.questionBirthCity,
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
                        return AppLocalizations.of(
                          context,
                        )!.selectSecurityQuestion;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  TextFormField(
                    controller: _securityAnswerController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.yourAnswer,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.answerRequired;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 6),
                  Text(
                    AppLocalizations.of(context)!.rememberAnswerNote,
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
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
                              if (authProvider.successMessage != null) {
                                _clearFormFields();
                                showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.success(
                                    message: authProvider.successMessage!,
                                  ),
                                );
                              } else {
                                showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.error(
                                    message: authProvider.errorMessage!,
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            authProvider.isLoading
                                ? AppLocalizations.of(context)!.pleaseWait
                                : AppLocalizations.of(context)!.signUp,
                            style: TextStyle(color: Colors.white, fontSize: 24),
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
