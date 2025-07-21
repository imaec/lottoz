import 'package:data/datasource/local/lotto_local_data_source.dart';
import 'package:data/datasource/local/setting_local_data_source.dart';
import 'package:data/datasource/remote/lotto_remote_data_source.dart';
import 'package:data/model/local/lotto/lotto_entity.dart';
import 'package:data/model/local/lotto/my_lotto_entity.dart';
import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:domain/model/lotto/my_lotto_dto.dart';
import 'package:domain/model/lotto/store_dto.dart';
import 'package:domain/repository/lotto_repository.dart';
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
