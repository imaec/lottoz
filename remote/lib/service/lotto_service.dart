import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'lotto_service.g.dart';

@RestApi()
abstract class LottoService {
  factory LottoService(Dio dio, {String baseUrl}) = _LottoService;

  @GET('common.do')
  Future<String> getLottoNumber({
    @Query('drwNo') required int drwNo,
    @Query('method') String method = "getLottoNumber",
  });
}
