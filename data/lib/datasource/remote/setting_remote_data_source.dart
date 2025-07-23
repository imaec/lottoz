import 'package:domain/model/lotto/my_lotto_dto.dart';

abstract class SettingRemoteDataSource {
  Future<int> backupMyNumbersToiCloud({
    required List<MyLottoDto> myLottoNumbers,
    required Function(String? message) onError,
  });

  Future<int> backupMyNumbersToGoogleDrive({
    required List<MyLottoDto> myLottoNumbers,
    required Function(String? message) onError,
  });

  Future<List<MyLottoDto>> restoreMyNumbersFromiCloud({required Function(String? message) onError});

  Future<List<MyLottoDto>> restoreMyNumbersFromGoogleDrive({
    required Function(String? message) onError,
  });
}
