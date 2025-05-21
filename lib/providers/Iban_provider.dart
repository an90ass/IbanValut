import 'package:flutter/material.dart';
import 'package:ibanvault/data/database/db_operations.dart';
import 'package:ibanvault/data/models/ibans_model.dart';

class IbansProvider with ChangeNotifier {
  final DbOperations dbOperations = DbOperations();

  List<Iban> _ibans = [];
  List<Iban> get ibans => _ibans;
  bool _isLoading =false;
  String? _errorMessage;
  String? _successMessage;
  bool get isLoading => _isLoading;
  String? get successMessage => _successMessage;
  String? get errorMessage => _errorMessage;



  Future<void> fetchMyIbans() async {
    _ibans = await dbOperations.getMyAllIbans();
    notifyListeners();
  }

  Future<void> addMyIban(Iban ibanModel) async {
  _isLoading = true;
  _successMessage = null;
  _errorMessage = null;
  notifyListeners();

  try {
    await dbOperations.insertMyIban(ibanModel.toMap());
    await fetchMyIbans();
    _successMessage = "IBAN saved successfully!";
  } catch (e) {
    _errorMessage = "Failed to save IBAN";
  } finally {
    _isLoading = false;
    notifyListeners();
  }
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
