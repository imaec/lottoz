import 'package:domain/model/lotto/my_lotto_dto.dart';
import 'package:domain/model/setting/backup_type.dart';
import 'package:domain/model/setting/purchase_notification_time_dto.dart';

abstract class SettingRepository {
  /// remote
  Future<int> backupMyNumbers({
    required List<MyLottoDto> myLottoNumbers,
    required BackupType backupType,
    required Function(String? message) onError,
  });

  Future<List<MyLottoDto>> restoreMyNumbers({
    required BackupType backupType,
    required Function(String? message) onError,
  });

  /// local
  Future<int> getStatisticsSize();

  Future<int> updateStatisticsSize({required int statisticsSize});

  Future<bool> isCheckLottoNotificationOn();

  Future<void> updateCheckLottoNotification({required bool isOn});

  Future<bool> isPurchaseNotificationOn();

  Future<void> updatePurchaseNotification({required bool isOn});

  Future<PurchaseNotificationTimeDto> getPurchaseNotificationTime();

  Future<void> updatePurchaseNotificationTime({
    required PurchaseNotificationTimeDto purchaseNotificationTime,
  });
}
