import 'package:domain/model/lotto/lotto_dto.dart';

abstract class LottoRepository {
  /// remote
  Future<LottoDto> getLottoNumber({required int drwNo});

  Future<int> getCurDrwNo();

  /// local
  Future<int> getLocalCurDrwNo();

  setLocalCurDrwNo({required int curDrwNo});

  Future<List<LottoDto>> getLottoNumbers();

  Future<int> saveLottoNumbers({required List<LottoDto> lottoNumbers});
}
