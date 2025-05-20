import 'package:flutter/widgets.dart';
import 'package:ibanvault/data/models/user_model.dart';
import 'package:ibanvault/services/authService.dart';
import '../services/futterSecureStorageService.dart' show SecureStorageService;

class AuthProvider with ChangeNotifier {
  final secureStorageService = SecureStorageService();
final auth = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? _successMessage;

  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<void> registerUser(User user) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await secureStorageService.registerUser(user);
      if (response) {
        _successMessage = 'User registered successfully.';
      } else {
        _errorMessage = 'Username already exists.';
      }
    } catch (e) {
      _errorMessage = 'Registration failed';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> userLogin(String userName,String password)async{
      _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await secureStorageService.userLogin(userName,password);
      print("aaaaaaaaaaaaaa");
      print(userName);
      print(password);
      if (response) {
        await auth.login();
        _successMessage = 'Loged in successfully.';
      } else {
        _errorMessage = 'Incorrect username or password.';
      }
    } catch (e) {
      _errorMessage = 'Login failed';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  

  }
Future<void> forgotPassword(String rememberQuestion) async {
  _isLoading = true;
  _errorMessage = null;
  _successMessage = null;
  notifyListeners();

  try {
    final isQuestionCorrect = await secureStorageService.forgetPassword(rememberQuestion);

    if (isQuestionCorrect) {
      _successMessage = "Security question matched!";
    } else {
      _errorMessage = "Incorrect answer to the security question.";
    }
  } catch (e) {
    _errorMessage = "An unexpected error occurred";
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

Future<void> editUserInfo(User user) async {
  _isLoading = true;
  _errorMessage = null;
  _successMessage = null;
  notifyListeners();

  try {
    final isEditingFinished = await secureStorageService.editUserInfo(user);

    if (isEditingFinished) {
      _successMessage = "Your information updated successfully. Try to login again!";
    } else {
      _errorMessage = "Failed to update user information.";
    }
  } catch (e) {
    _errorMessage = "An unexpected error occurred";
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<void> logOut()async{
    await auth.logOut();
  }
}
