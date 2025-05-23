import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static DbHelper? _dbHelper;
  static Database? _database;
   DbHelper._createInstance();//private constructor if the class is not private it can be accessed from outside the class

  factory DbHelper() { // this function is used to create a singleton instance of the DbHelper class for db access
    _dbHelper ??= DbHelper._createInstance();
    return _dbHelper!;
  }

Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDb();
    }
    return _database!;
  }
  Future<Database> initializeDb() async{
    Directory directory = await getApplicationDocumentsDirectory();
        String path = directory.path + "/ibanVault.db";
        var ibanVaultDb = await openDatabase(path,version: 2, onCreate :_createDb,onUpgrade: _onUpgrade,);
      return ibanVaultDb;
  }
  void _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE ibans(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bankName TEXT NOT NULL,
        ibanNumber TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
     await db.execute('''
    CREATE TABLE friend_ibans (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      bankName TEXT NOT NULL,
      iban TEXT NOT NULL,
      createdAt TEXT NOT NULL
    )
  ''');
  }
  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    await db.execute('''
  CREATE TABLE friend_ibans (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    bankName TEXT NOT NULL,
    iban TEXT NOT NULL,
    createdAt TEXT NOT NULL
  )
''');

  }
}

  Future closeDb() async {
  final db = await database;
  await db.close();
}

}