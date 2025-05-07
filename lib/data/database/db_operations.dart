import 'package:ibanvault/data/database/db_helper.dart';
import 'package:ibanvault/data/models/friend_ibans_model.dart';
import 'package:ibanvault/data/models/ibans_model.dart';
import 'package:sqflite/sqflite.dart';

class DbOperations {
  Future<void> insertMyIban(Map<String, dynamic> data) async {
    final db = await DbHelper().database;
    await db.insert(
      'ibans',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Iban>> getMyAllIbans() async {
    final db = await DbHelper().database;
    final List<Map<String, dynamic>> result = await db.query('ibans',
     orderBy: 'createdAt DESC',);

    return result.map((map) => Iban.fromMap(map)).toList();
  }

  Future<void> updateMyIban(Iban iban) async {
    final db = await DbHelper().database;
    await db.update(
      'ibans',
      iban.toMap(),
      where: 'id = ?',
      whereArgs: [iban.id],
    );
  } 
  Future<void> deleteMyIban(String id) async {
    final db = await DbHelper().database;
    await db.delete(
      'ibans',
      where: 'id = ?',
      whereArgs: [id],
      
    );
  }

   Future<void> insertFriendIban(Map<String, dynamic> data) async {
    print(data);
    final db = await DbHelper().database;
    try{
 await db.insert(
      'friend_ibans',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    }catch(e){
      print(e);
    }
   
  }

  Future<List<FriendIban>> getAllFriendIbans() async {
    final db = await DbHelper().database;
    final List<Map<String, dynamic>> result = await db.query(
      'friend_ibans',
      orderBy: 'createdAt DESC',
    );

    return result.map((map) => FriendIban.fromMap(map)).toList();
  }

  Future<void> updateFriendIban(FriendIban iban) async {
    final db = await DbHelper().database;
    await db.update(
      'friend_ibans',
      iban.toMap(),
      where: 'id = ?',
      whereArgs: [iban.id],
    );
  }

  Future<void> deleteFriendIban(String id) async {
    final db = await DbHelper().database;
    await db.delete(
      'friend_ibans',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
