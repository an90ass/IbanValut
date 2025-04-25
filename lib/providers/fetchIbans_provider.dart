import 'package:flutter/material.dart';
import 'package:ibanvault/data/database/db_operations.dart';
import 'package:ibanvault/data/models/ibans_model.dart';

class FetchibansProvider with ChangeNotifier {
  final DbOperations dbOperations = DbOperations();

  List<Iban> _ibans = [];
  List<Iban> get ibans => _ibans;

  Future<void> fetchIbans() async {
    _ibans = await dbOperations.getAllIbans();
    print(_ibans);
    notifyListeners();
  }
}
