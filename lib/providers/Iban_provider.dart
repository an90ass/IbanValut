import 'package:flutter/material.dart';
import 'package:ibanvault/data/database/db_operations.dart';
import 'package:ibanvault/data/models/ibans_model.dart';

class IbansProvider with ChangeNotifier {
  final DbOperations dbOperations = DbOperations();

  List<Iban> _ibans = [];
  List<Iban> get ibans => _ibans;

  Future<void> fetchMyIbans() async {
    _ibans = await dbOperations.getMyAllIbans();
    notifyListeners();
  }

  Future<void> addMyIban(Iban ibanModel) async {
    await dbOperations.insertMyIban(ibanModel.toMap());
    await fetchMyIbans();
  }

  Future<void> updateIban(Iban updatedIban) async {
    await dbOperations.updateMyIban(updatedIban);
    await fetchMyIbans();
  }

  Future<void> deleteMyIban(String id) async {
    await dbOperations.deleteMyIban(id);
    await fetchMyIbans();
  }
}
