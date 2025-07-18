import 'dart:convert';

import 'package:data/data.dart';
import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:remote/service/lotto_service.dart';

class LottoRemoteDataSourceImpl extends LottoRemoteDataSource {
  final LottoService _service;

  LottoRemoteDataSourceImpl({required LottoService service}) : _service = service;

  @override
  Future<LottoDto> getLottoNumber({required int drwNo}) async {
    final responseRaw = await _service.getLottoNumber(drwNo: drwNo);
    final jsonMap = jsonDecode(responseRaw);
    final response = LottoResponse.fromJson(jsonMap);
    return response.mapper();
  }
}
