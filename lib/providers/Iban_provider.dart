import 'package:flutter/material.dart';
import 'package:ibanvault/data/database/db_operations.dart';
import 'package:ibanvault/data/models/ibans_model.dart';

class IbansProvider with ChangeNotifier {
  final DbOperations dbOperations = DbOperations();

  List<Iban> _ibans = [];
  List<Iban> get ibans => _ibans;

  Future<void> fetchIbans() async {
    _ibans = await dbOperations.getAllIbans();
    notifyListeners();
  }

  Future<void> addIban(Iban ibanModel) async {
    await dbOperations.insertIban(ibanModel.toMap());
    await fetchIbans();
  }

  Future<void> updateIban(Iban updatedIban) async {
    await dbOperations.updateIban(updatedIban);
    await fetchIbans();
  }

  Future<void> deleteIban(String id) async {
    await dbOperations.deleteIban(id);
    await fetchIbans();
  }
}
