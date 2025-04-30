import 'package:ibanvault/data/database/db_helper.dart';
import 'package:ibanvault/data/models/ibans_model.dart';
import 'package:sqflite/sqflite.dart';

class DbOperations {
  Future<void> insertIban(Map<String, dynamic> data) async {
    final db = await DbHelper().database;
    await db.insert(
      'ibans',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Iban>> getAllIbans() async {
    final db = await DbHelper().database;
    final List<Map<String, dynamic>> result = await db.query('ibans');

    return result.map((map) => Iban.fromMap(map)).toList();
  }

  Future<void> updateIban(Iban iban) async {
    final db = await DbHelper().database;
    await db.update(
      'ibans',
      iban.toMap(),
      where: 'id = ?',
      whereArgs: [iban.id],
    );
  } 
  Future<void> deleteIban(String id) async {
    final db = await DbHelper().database;
    await db.delete(
      'ibans',
      where: 'id = ?',
      whereArgs: [id],
      
    );
  }
}
