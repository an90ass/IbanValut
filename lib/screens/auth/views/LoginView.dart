import 'package:flutter/material.dart';
import 'package:ibanvault/core/routes/route_names.dart';
import 'package:ibanvault/core/utils/AppColors.dart';
import 'package:ibanvault/l10n/app_localizations.dart';
import 'package:ibanvault/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../data/models/user_model.dart';
import '../../../services/futterSecureStorageService.dart';

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
  String? _selectedQuestion;
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
                AppLocalizations.of(context)!.loginPage,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                AppLocalizations.of(context)!.loginSubtitle,
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
                        labelText: AppLocalizations.of(context)!.username,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
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
                        if (value == null || value.length < 6) {
                          return AppLocalizations.of(context)!.passwordRequired;
                        }
                      },
                    ),

                    SizedBox(height: 24),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final username =
                                    _usernameController.text.trim();
                                final password =
                                    _passwordController.text.trim();
                                print("Login with $username and $password");
                                await authProvider.userLogin(
                                  context,
                                  username,
                                  password,
                                );
                                if (authProvider.successMessage != null) {
                                  _clearFormFields();
                                  Navigator.pushReplacementNamed(
                                    context,
                                    Routenames.home,
                                  );
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
                                  : AppLocalizations.of(context)!.login,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
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
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          _showQuestionFieled(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.forgotPassword,
                        ),
                      ),
                    ),
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

  void _showQuestionFieled(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? _selectedQuestion;
    final TextEditingController _questionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.securityQuestionTitle),
              SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!.securityQuestionSubtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          content: SizedBox(
            width: 300,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.chooseQuestion,
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
                      _selectedQuestion = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.questionRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _questionController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.typeAnswer,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppLocalizations.of(context)!.answerRequired;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // زر الإلغاء
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: AppColors.background),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                          color: AppColors.background,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                // زر الإرسال
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              print("Selected Question: $_selectedQuestion");
                              print("Answer: ${_questionController.text}");
                              await authProvider.forgotPassword(
                                _questionController.text.trim(),
                              );
                              if (authProvider.successMessage != null) {
                                Navigator.pop(context);
                                _buildResetForm();
                              } else {
                                showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.error(
                                    message:
                                        AppLocalizations.of(
                                          context,
                                        )!.securityQuestionIncorrect,
                                  ),
                                );
                              }
                            }
                          },
                          child:
                              authProvider.isLoading
                                  ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(
                                    AppLocalizations.of(context)!.send,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _buildResetForm() {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _answerController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.resetAccount),
          content: SizedBox(
            width: 300,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Username field
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.newUsername,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter a username";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Security Question dropdown
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context)!.newSecurityQuestion,
                        border: OutlineInputBorder(),
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
                        _selectedQuestion = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.questionRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Answer field
                    TextFormField(
                      controller: _answerController,
                      decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.yourAnswer,

                        hintText: AppLocalizations.of(context)!.typeAnswer,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLocalizations.of(context)!.answerRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // New password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.newPassword,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return AppLocalizations.of(context)!.passwordTooShort;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // New password
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context)!.confirmNewPassword,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return AppLocalizations.of(context)!.passwordTooShort;
                        } else if (value.trim() !=
                            _passwordController.text.trim()) {
                          return AppLocalizations.of(
                            context,
                          )!.passwordsDontMatch;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: AppColors.background),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                          color: AppColors.background,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final user = User(
                                user_name: _usernameController.text.trim(),
                                password: _passwordController.text.trim(),
                                remeberQuestion: _answerController.text.trim(),
                              );

                              await authProvider.editUserInfo(user);

                              if (authProvider.successMessage != null) {
                                _clearFormFields();
                                Navigator.pop(context);

                                showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.success(
                                    message:
                                        AppLocalizations.of(
                                          context,
                                        )!.userInfoUpdated,
                                  ),
                                );
                              } else {
                                showTopSnackBar(
                                  Overlay.of(context),
                                  CustomSnackBar.error(
                                    message:
                                        AppLocalizations.of(
                                          context,
                                        )!.userInfoUpdateFailed
                                  ),
                                );
                              }
                            }
                          },
                          child:
                              authProvider.isLoading
                                  ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(
                                    AppLocalizations.of(context)!.submit,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
