import 'package:data/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LottoLocalDataSourceImpl extends LottoLocalDataSource {

  @override
  Future<int> getCurDrwNo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('curDrwNo') ?? 1;
  }

  @override
  setCurDrwNo(curDrwNo) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('curDrwNo', curDrwNo);
  }
}
