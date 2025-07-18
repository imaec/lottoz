import 'package:domain/model/lotto/lotto_dto.dart';

abstract class LottoRepository {
  Future<LottoDto> getLottoNumber({required int drwNo});
}
