import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const String _lottoZDb = 'lotto_z_db';
const String lottoTable = 'lottoTable';
const String myLottoTable = 'myLottoTable';

class DatabaseHelper {
  DatabaseHelper._databaseHelper();

  static final DatabaseHelper instance = DatabaseHelper._databaseHelper();
  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, '$_lottoZDb.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $lottoTable (
        drwNo INTEGER PRIMARY KEY,
        drwNoDate TEXT NOT NULL,
        drwtNo1 INTEGER NOT NULL,
        drwtNo2 INTEGER NOT NULL,
        drwtNo3 INTEGER NOT NULL,
        drwtNo4 INTEGER NOT NULL,
        drwtNo5 INTEGER NOT NULL,
        drwtNo6 INTEGER NOT NULL,
        bnusNo INTEGER NOT NULL,
        firstAccumamnt REAL NOT NULL,
        firstPrzwnerCo INTEGER NOT NULL,
        firstWinamnt REAL NOT NULL,
        totSellamnt REAL NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE $myLottoTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        no1 INTEGER NOT NULL,
        no2 INTEGER NOT NULL,
        no3 INTEGER NOT NULL,
        no4 INTEGER NOT NULL,
        no5 INTEGER NOT NULL,
        no6 INTEGER NOT NULL
    )
    ''');
  }
}
