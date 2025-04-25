import 'package:flutter/material.dart';
import 'package:ibanvault/data/database/db_operations.dart';
import 'package:ibanvault/data/models/ibans_model.dart';
import 'package:ibanvault/providers/fetchIbans_provider.dart';

class AddIbanProvider with ChangeNotifier {
  String _bankName = '';
  String _ibanNumber ='';
final db_operations = DbOperations(); 
  Future<void> addIban({
    required Iban ibanModel}
  ) async{
    await db_operations.insertIban(ibanModel.toMap());
    await FetchibansProvider().fetchIbans();
      notifyListeners(); 

  }
}