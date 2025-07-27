import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:domain/model/lotto/lotto_win_price_dto.dart';
import 'package:domain/model/lotto/store_dto.dart';

abstract class LottoRemoteDataSource {
  Future<LottoDto> getLottoNumber({required int drwNo});

  Future<int> getCurDrwNo();

  Future<int> getDatabaseCurDrwNo();

  Future<List<LottoDto>> getLottoNumbers();

  Future<Map<int, List<StoreDto>>> getStores({required int drwNo});

  Future<List<StoreDto>> getFirstStores({required int drwNo});

  Future<List<StoreDto>> getSecondStores({required int drwNo});

  Future<List<LottoWinPriceDto>> getWinPrices({required int drwNo});

  Future<void> saveLottoNumbers({required List<LottoDto> lottoNumbers});
}
