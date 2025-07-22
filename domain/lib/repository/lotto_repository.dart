import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:domain/model/lotto/lotto_win_price_dto.dart';
import 'package:domain/model/lotto/my_lotto_dto.dart';

import '../model/lotto/store_dto.dart';

abstract class LottoRepository {
  /// remote
  Future<LottoDto> getLottoNumber({required int drwNo});

  Future<int> getCurDrwNo();

  Future<int> getFirebaseCurDrwNo();

  Future<List<LottoDto>> getFirebaseLottoNumbers();

  Future<Map<int, List<StoreDto>>> getStores({required int drwNo});

  Future<List<StoreDto>> getFirstStores({required int drwNo});

  Future<List<StoreDto>> getSecondStores({required int drwNo});

  Future<List<LottoWinPriceDto>> getWinPrices({required int drwNo});

  Future<void> setFirebaseCurDrwNo({required int curDrwNo});

  Future<void> saveLottoNumbersFirebase({required List<LottoDto> lottoNumbers});

  /// local
  Future<int> getLocalCurDrwNo();

  Future<int> setLocalCurDrwNo({required int curDrwNo});

  Future<List<LottoDto>> getLocalLottoNumbers();

  Future<int> saveLottoNumbersLocal({required List<LottoDto> lottoNumbers});

  Future<List<MyLottoDto>> getMyLottoNumbers();

  Future<int> saveMyLottoNumber({required MyLottoDto myLottoNumber});

  Future<int> saveMyLottoNumbers({required List<MyLottoDto> myLottoNumbers});

  Future<int> removeMyNumber({required int id});
}
