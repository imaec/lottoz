import 'package:data/datasource/local/setting_local_data_source.dart';
import 'package:data/datasource/remote/setting_remote_data_source.dart';
import 'package:domain/model/lotto/my_lotto_dto.dart';
import 'package:domain/model/setting/backup_type.dart';
import 'package:domain/model/setting/purchase_notification_time_dto.dart';
import 'package:domain/repository/setting_repository.dart';

class SettingRepositoryImpl extends SettingRepository {
  final SettingRemoteDataSource _remoteDataSource;
  final SettingLocalDataSource _localDataSource;

  SettingRepositoryImpl({
    required SettingRemoteDataSource remoteDataSource,
    required SettingLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  /// remote
  @override
  Future<int> backupMyNumbers({
    required List<MyLottoDto> myLottoNumbers,
    required BackupType backupType,
    required Function(String? message) onError,
  }) {
    switch (backupType) {
      case BackupType.iCloud:
        return _remoteDataSource.backupMyNumbersToiCloud(
          myLottoNumbers: myLottoNumbers,
          onError: onError,
        );
      case BackupType.googleDrive:
        return _remoteDataSource.backupMyNumbersToGoogleDrive(
          myLottoNumbers: myLottoNumbers,
          onError: onError,
        );
    }
  }

  @override
  Future<List<MyLottoDto>> restoreMyNumbers({
    required BackupType backupType,
    required Function(String? message) onError,
  }) {
    switch (backupType) {
      case BackupType.iCloud:
        return _remoteDataSource.restoreMyNumbersFromiCloud(onError: onError);
      case BackupType.googleDrive:
        return _remoteDataSource.restoreMyNumbersFromGoogleDrive(onError: onError);
    }
  }

  /// local
  @override
  Future<int> getStatisticsSize() {
    return _localDataSource.getStatisticsSize();
  }

  @override
  Future<int> updateStatisticsSize({required int statisticsSize}) {
    return _localDataSource.updateStatisticsSize(statisticsSize: statisticsSize);
  }

  @override
  Future<bool> isCheckLottoNotificationOn() {
    return _localDataSource.isCheckLottoNotificationOn();
  }

  @override
  Future<void> updateCheckLottoNotification({required bool isOn}) {
    return _localDataSource.updateCheckLottoNotification(isOn: isOn);
  }

  @override
  Future<bool> isPurchaseNotificationOn() {
    return _localDataSource.isPurchaseNotificationOn();
  }

  @override
  Future<void> updatePurchaseNotification({required bool isOn}) {
    return _localDataSource.updatePurchaseNotification(isOn: isOn);
  }

  @override
  Future<PurchaseNotificationTimeDto> getPurchaseNotificationTime() async {
    return PurchaseNotificationTimeDto.fromJson(
      await _localDataSource.getPurchaseNotificationTime(),
    );
  }

  @override
  Future<void> updatePurchaseNotificationTime({
    required PurchaseNotificationTimeDto purchaseNotificationTime,
  }) {
    return _localDataSource.updatePurchaseNotificationTime(
      purchaseNotificationTime: purchaseNotificationTime.toJson(),
    );
  }
}
