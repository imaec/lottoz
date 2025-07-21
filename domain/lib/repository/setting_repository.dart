abstract class SettingRepository {
  /// local
  Future<int> getStatisticsSize();

  Future<int> updateStatisticsSize({required int statisticsSize});
}
