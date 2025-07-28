abstract class SettingLocalDataSource {
  Future<int> getStatisticsSize();

  Future<int> updateStatisticsSize({required int statisticsSize});

  Future<bool> isCheckLottoNotificationOn();

  Future<void> updateCheckLottoNotification({required bool isOn});

  Future<bool> isPurchaseNotificationOn();

  Future<void> updatePurchaseNotification({required bool isOn});

  Future<Map<String, dynamic>> getPurchaseNotificationTime();

  Future<void> updatePurchaseNotificationTime({
    required Map<String, dynamic> purchaseNotificationTime,
  });
}
