import 'package:domain/model/lotto/my_lotto_dto.dart';
import 'package:domain/model/setting/backup_type.dart';

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
}
