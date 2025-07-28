import 'dart:convert';

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

  @override
  Future<bool> isCheckLottoNotificationOn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isCheckLottoNotificationOn') ?? false;
  }

  @override
  Future<void> updateCheckLottoNotification({required bool isOn}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isCheckLottoNotificationOn', isOn);
  }

  @override
  Future<bool> isPurchaseNotificationOn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isPurchaseNotificationOn') ?? false;
  }

  @override
  Future<void> updatePurchaseNotification({required bool isOn}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPurchaseNotificationOn', isOn);
  }

  @override
  Future<Map<String, dynamic>> getPurchaseNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();

    return jsonDecode(
      prefs.getString('purchaseNotificationTimeDayOfWeek') ??
          '''{
      "dayOfWeek": "금",
      "amPm": "오후",
      "hour": 6,
      "minute": 0
    }''',
    );
  }

  @override
  Future<void> updatePurchaseNotificationTime({
    required Map<String, dynamic> purchaseNotificationTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('purchaseNotificationTimeDayOfWeek', jsonEncode(purchaseNotificationTime));
  }
}
