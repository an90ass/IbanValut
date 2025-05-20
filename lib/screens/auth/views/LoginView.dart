import 'package:flutter/material.dart';
import 'package:ibanvault/core/routes/route_names.dart';
import 'package:ibanvault/core/utils/AppColors.dart';
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
                             showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(
        message: authProvider.successMessage!,
      ),
    );
                          } else  {
                                                     showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: authProvider.errorMessage!,
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
                      SizedBox(height: 10,),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: (){
                            _showQuestionFieled(context);
                          },
                          child: Text("I forgot my password")),
                      )
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
            Text("Security Question"),
            SizedBox(height: 4),
            Text(
              "Please select and answer the question you entered when you signed up.",
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
                    labelText: "Choose a question",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  items: [
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
                    _selectedQuestion = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a question';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    hintText: "Type your answer",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your answer';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child){

            
           return TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  print("Selected Question: $_selectedQuestion");
                  print("Answer: ${_questionController.text}");
                  await authProvider.forgotPassword(_questionController.text.trim());
                  if(authProvider.successMessage != null){
                    Navigator.pop(context);
                    _buildResetForm();

                  }else{
            showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: authProvider.errorMessage!,
      ),
    );
                  }
       
                }
              },
              child: Text(authProvider.isLoading ? "Please wait a moment" : "Send"),
            );
     } ),
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
    final TextEditingController _confirmPasswordController = TextEditingController();

  String? _selectedQuestion;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Reset Account"),
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
                      labelText: "New Username",
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
                      labelText: "New Security Question",
                      border: OutlineInputBorder(),
                    ),
                    items: [
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
                      _selectedQuestion = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a question';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Answer field
                  TextFormField(
                    controller: _answerController,
                    decoration: InputDecoration(
                      hintText: "Type your answer",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your answer';
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
                      labelText: "New Password",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return "Password must be at least 6 characters";
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
                      labelText: "Confirm New Password",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return "Password must be at least 6 characters";
                      }else if(value.trim() != _passwordController.text.trim()){
                         return "Passwords doesnt match";
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {

            
           return TextButton(
              onPressed: ()async {
                if (_formKey.currentState!.validate()) {
                  final username = _usernameController.text.trim();
                  final question = _selectedQuestion;
                  final answer = _answerController.text.trim();
                  final newPassword = _passwordController.text.trim();
                  final user = User(
                    user_name: _usernameController.text.trim(),
                    password: _passwordController.text.trim(),
                    remeberQuestion: _answerController.text.trim()
                  );
                  await authProvider.editUserInfo(user);
            
                  Navigator.pop(context);
                       if(authProvider.successMessage!=null){
                                _clearFormFields();
                                Navigator.pushReplacementNamed(context, Routenames.home);
                                                                               showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(
        message: authProvider.successMessage!,
      ),
    );
                          } else  {
                                                                                showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: authProvider.errorMessage!,
      ),
    );
                            
                          };
                }
              },
              child: Text( authProvider.isLoading ?"Please wait a moment": "Submit"),
            );}
          ),
        ],
      );
    },
  );
}

}
