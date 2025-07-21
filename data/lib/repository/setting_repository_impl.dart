import 'package:data/datasource/local/setting_local_data_source.dart';
import 'package:domain/repository/setting_repository.dart';

class SettingRepositoryImpl extends SettingRepository {
  final SettingLocalDataSource _localDataSource;

  SettingRepositoryImpl({
    required SettingLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  /// local
  @override
  Future<int> getStatisticsSize() {
    return _localDataSource.getStatisticsSize();
  }

  @override
  Future<int> updateStatisticsSize({required int statisticsSize}) {
    return _localDataSource.updateStatisticsSize(statisticsSize: statisticsSize);
  }
}
