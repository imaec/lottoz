import 'package:data/data.dart';
import 'package:local/db/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class LottoLocalDataSourceImpl extends LottoLocalDataSource {
  @override
  Future<int> getCurDrwNo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('curDrwNo') ?? 1;
  }

  @override
  Future<int> setCurDrwNo({required int curDrwNo}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('curDrwNo', curDrwNo);
    return curDrwNo;
  }

  @override
  Future<List<LottoEntity>> getLottoNumbers() async {
    final db = await DatabaseHelper.instance.database;
    final queries = await db.query(lottoTable);
    final lottoNumbers = queries.map((e) => LottoEntity.fromJson(e)).toList();
    return lottoNumbers;
  }

  @override
  Future<int> saveLottoNumbers({required List<LottoEntity> lottoNumbers}) async {
    final db = await DatabaseHelper.instance.database;
    return await db.transaction((transaction) async {
      var resultSum = 0;
      for (final lotto in lottoNumbers) {
        resultSum += await transaction.insert(
          lottoTable,
          lotto.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      return resultSum;
    });
  }

  @override
  Future<List<MyLottoEntity>> getMyLottoNumbers() async {
    final db = await DatabaseHelper.instance.database;
    final queries = await db.query(myLottoTable);
    final myLottoNumbers = queries.map((e) => MyLottoEntity.fromJson(e)).toList();
    return myLottoNumbers;
  }

  @override
  Future<int> saveMyLottoNumber({required MyLottoEntity myLottoNumber}) async {
    final db = await DatabaseHelper.instance.database;
    return await db.transaction((transaction) async {
      return await transaction.insert(
        myLottoTable,
        myLottoNumber.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  @override
  Future<int> saveMyLottoNumbers({required List<MyLottoEntity> myLottoNumbers}) async {
    final db = await DatabaseHelper.instance.database;
    return await db.transaction((transaction) async {
      var resultSum = 0;
      for (final lotto in myLottoNumbers) {
        resultSum += await transaction.insert(
          myLottoTable,
          lotto.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      return resultSum;
    });
  }

  @override
  Future<int> removeMyNumber({required int id}) async {
    final db = await DatabaseHelper.instance.database;
    return db.delete(myLottoTable, where: 'id = ?', whereArgs: [id]);
  }
}
