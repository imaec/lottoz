import 'package:domain/model/lotto/lotto_dto.dart';

import '../model/lotto/store_dto.dart';

abstract class LottoRepository {
  /// remote
  Future<LottoDto> getLottoNumber({required int drwNo});

  Future<int> getCurDrwNo();

  Future<List<StoreDto>> getStores({required int drwNo});

  /// local
  Future<int> getLocalCurDrwNo();

  setLocalCurDrwNo({required int curDrwNo});

  Future<List<LottoDto>> getLottoNumbers();

  Future<int> saveLottoNumbers({required List<LottoDto> lottoNumbers});
}
