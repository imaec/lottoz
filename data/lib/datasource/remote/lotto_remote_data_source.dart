import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:domain/model/lotto/store_dto.dart';

abstract class LottoRemoteDataSource {
  Future<LottoDto> getLottoNumber({required int drwNo});

  Future<int> getCurDrwNo();

  Future<List<StoreDto>> getStores({required int drwNo});
}
