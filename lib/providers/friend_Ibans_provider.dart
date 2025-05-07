import 'package:flutter/material.dart';
import 'package:ibanvault/data/database/db_operations.dart';
import 'package:ibanvault/data/models/friend_ibans_model.dart';

class FriendIbansProvider with ChangeNotifier {
  final DbOperations dbOperations = DbOperations();

  List<FriendIban> _friendIbans = [];
  List<FriendIban> get friendIbans => _friendIbans;

  Future<void> fetchFriendIbans() async {
    _friendIbans = await dbOperations.getAllFriendIbans();
    notifyListeners();
  }

  Future<void> addFriendIban(FriendIban ibanModel) async {
    await dbOperations.insertFriendIban(ibanModel.toMap());
    await fetchFriendIbans();
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
