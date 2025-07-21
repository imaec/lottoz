abstract class SettingLocalDataSource {
  Future<int> getStatisticsSize();

  Future<int> updateStatisticsSize({required int statisticsSize});
}
