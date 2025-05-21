import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<void> login()async{
        final prefs = await SharedPreferences.getInstance();

await prefs.setBool('isLoggedIn',true);
  }

      Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
  await prefs.remove('isLoggedIn');
  }
    Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

}