import 'package:data/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingLocalDataSourceImpl extends SettingLocalDataSource {
  @override
  Future<int> getStatisticsSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('statisticsSize') ?? 20;
  }

  @override
  Future<int> updateStatisticsSize({required int statisticsSize}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('statisticsSize', statisticsSize);
    return statisticsSize;
  }
}
