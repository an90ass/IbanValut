import 'package:flutter/material.dart';
import 'package:ibanvault/data/database/db_operations.dart';
import 'package:ibanvault/data/models/friend_ibans_model.dart';

class FriendIbansProvider with ChangeNotifier {
  final DbOperations dbOperations = DbOperations();

  List<FriendIban> _friendIbans = [];
  List<FriendIban> get friendIbans => _friendIbans;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get successMessage => _successMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchFriendIbans() async {
    _friendIbans = await dbOperations.getAllFriendIbans();
    notifyListeners();
  }

  Future<void> addFriendIban(FriendIban ibanModel) async {
    _isLoading = true;
    _successMessage = null;
    _errorMessage = null;
    notifyListeners();

    try {
      await dbOperations.insertFriendIban(ibanModel.toMap());
      await fetchFriendIbans();
      _successMessage = "Friend IBAN saved successfully!";
    } catch (e) {
      _errorMessage = "Failed to save friend IBAN: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateFriendIban(FriendIban updatedIban) async {
    await dbOperations.updateFriendIban(updatedIban);
    await fetchFriendIbans();
  }

  Future<void> deleteFriendIban(String id) async {
    await dbOperations.deleteFriendIban(id);
    await fetchFriendIbans();
  }
}
