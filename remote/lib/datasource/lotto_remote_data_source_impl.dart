import 'dart:convert';

import 'package:data/data.dart';
import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
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

  @override
  Future<int> getCurDrwNo() async {
    final response = await http.get(
      Uri.parse('https://www.dhlottery.co.kr/common.do?method=main&mainMode=default'),
    );
    if (response.statusCode == 200) {
      final document = html_parser.parse(response.body);
      final curDrwNo = int.parse(document.getElementById('lottoDrwNo')?.text ?? '');
      return curDrwNo;
    } else {
      return 0;
    }
  }
}
