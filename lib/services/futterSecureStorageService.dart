import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ibanvault/data/models/user_model.dart';

class SecureStorageService {
final storage = FlutterSecureStorage();

 Future<bool> registerUser(User user) async {
  final existingUsername = await storage.read(key: 'username');

  if (existingUsername != null && existingUsername == user.user_name) {
    return false;
  }

  final hashedPassword = sha256.convert(utf8.encode(user.password)).toString();
  await storage.write(key: 'username', value: user.user_name);
  await storage.write(key: 'password', value: hashedPassword);
  await storage.write(key: 'remeberQuestion', value: user.remeberQuestion);

  return true;
}

  Future<bool> userLogin(String user_name, String password)async{
    final storedUserName = await storage.read(key: 'username');
    final storedPassword = await storage.read(key: 'password');
        final inputHashed = sha256.convert(utf8.encode(password)).toString();
    print(storedUserName);
        print(user_name);

  final isMatch = storedUserName == user_name && storedPassword == inputHashed;

  return isMatch;
}

  Future<bool> forgetPassword (String remeberQuestion) async {
    final storedRememberQuestion = await storage.read(key: 'remeberQuestion');
    return storedRememberQuestion == remeberQuestion;
  }

Future<void> editUserInfo(User user) async {
  final existingUsername = await storage.read(key: 'username');
  if (existingUsername == null) {
    throw Exception("No user to edit");
  }
    await storage.deleteAll();
  final hashedPassword = sha256.convert(utf8.encode(user.password)).toString();

  if (user.user_name.isNotEmpty) {
    await storage.write(key: 'username', value: user.user_name);
  }

  if (user.password.isNotEmpty) {
    await storage.write(key: 'password', value: hashedPassword);
  }

  if (user.remeberQuestion.isNotEmpty) {
    await storage.write(key: 'remeberQuestion', value: user.remeberQuestion);
  }
}

}