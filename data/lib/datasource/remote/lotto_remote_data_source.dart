import 'package:domain/model/lotto/lotto_dto.dart';

abstract class LottoRemoteDataSource {
  Future<LottoDto> getLottoNumber({required int drwNo});
}
