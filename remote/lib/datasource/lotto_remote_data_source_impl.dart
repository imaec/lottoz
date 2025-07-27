import 'dart:convert';

import 'package:charset_converter/charset_converter.dart';
import 'package:data/data.dart';
import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:domain/model/lotto/lotto_win_price_dto.dart';
import 'package:domain/model/lotto/store_dto.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:remote/service/lotto_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      final curDrwNo = int.parse(document
          .getElementById('lottoDrwNo')
          ?.text ?? '');
      return curDrwNo;
    } else {
      return 0;
    }
  }

  @override
  Future<int> getDatabaseCurDrwNo() async {
    final response = await Supabase.instance.client.from('lotto')
        .select('drw_no')
        .order('drw_no', ascending: false)
        .limit(1);

    if (response.isNotEmpty) {
      return response.single['drw_no'] as int;
    } else {
      return 0;
    }
  }

  @override
  Future<List<LottoDto>> getLottoNumbers() async {
    final response = await Supabase.instance.client
        .from('lotto')
        .select()
        .order('drw_no', ascending: false);
    final data = response as List<dynamic>;
    final lottoList = data.map((json) => LottoDto.fromJson(json)).toList();

    return lottoList;
  }

  @override
  Future<Map<int, List<StoreDto>>> getStores({required int drwNo}) async {
    final storeFutures = await Future.wait([
      getFirstStores(drwNo: drwNo),
      getSecondStores(drwNo: drwNo),
    ]);

    return {1: storeFutures[0], 2: storeFutures[1]};
  }

  @override
  Future<List<StoreDto>> getFirstStores({required int drwNo}) async {
    final List<StoreDto> stores = [];
    final response = await http.post(
      Uri.parse('https://www.dhlottery.co.kr/store.do?method=topStore&pageGubun=L645'),
      body: {'gameNo': '5133', 'drwNo': '$drwNo'},
    );
    if (response.statusCode != 200) return [];

    final decodedBody = await CharsetConverter.decode("euc-kr", response.bodyBytes);
    final document = html_parser.parse(decodedBody);
    final elements = document.getElementsByClassName('group_content');
    if (elements.isEmpty) return [];

    final tbody = elements[0].getElementsByTagName('tbody');
    if (tbody.isNotEmpty) {
      final trs = tbody[0].getElementsByTagName('tr');
      for (var tr in trs) {
        final cells = tr.querySelectorAll('td');
        if (cells.length >= 4) {
          final storeName = cells[1].text.trim();
          final type = cells[2].text.trim();
          final address = cells[3].text.trim();

          stores.add(StoreDto(storeName: storeName, address: address, type: type));
        }
      }
    }

    return stores;
  }

  @override
  Future<List<StoreDto>> getSecondStores({required int drwNo}) async {
    int maxPage = await _getSecondStorePage(drwNo: drwNo);
    List<StoreDto> secondStores = [];

    for (int page = 1; page <= maxPage; page++) {
      final response = await http.post(
        Uri.parse('https://www.dhlottery.co.kr/store.do?method=topStore&pageGubun=L645'),
        body: {'gameNo': '5133', 'drwNo': '$drwNo', 'rank': '2', 'nowPage': page.toString()},
      );
      if (response.statusCode != 200) break;

      final decodedBody = await CharsetConverter.decode("euc-kr", response.bodyBytes);
      final document = html_parser.parse(decodedBody);
      final elements = document.getElementsByClassName('group_content');
      if (elements.length < 2) break;

      final tbody = elements[1].getElementsByTagName('tbody');
      if (tbody.isNotEmpty) {
        final trs = tbody[0].getElementsByTagName('tr');
        for (var tr in trs) {
          final cells = tr.querySelectorAll('td');
          if (cells.length >= 4) {
            final storeName = cells[1].text.trim();
            final address = cells[2].text.trim();

            secondStores.add(StoreDto(storeName: storeName, address: address, type: ''));
          }
        }
      }
    }

    return secondStores;
  }

  Future<int> _getSecondStorePage({required int drwNo}) async {
    final uri = Uri.parse('https://www.dhlottery.co.kr/store.do?method=topStore&pageGubun=L645');
    final response = await http.post(uri, body: {'rank': '2', 'nowPage': '1'});
    if (response.statusCode != 200) return 1;

    final decodedBody = await CharsetConverter.decode("euc-kr", response.bodyBytes);
    final document = html_parser.parse(decodedBody);
    final pageLinks = document.querySelectorAll('div.paginate_common a');
    int maxPage = 1;
    for (var link in pageLinks) {
      final text = link.text.trim();
      final pageNum = int.tryParse(text);
      if (pageNum != null && pageNum > maxPage) {
        maxPage = pageNum;
      }
    }
    return maxPage;
  }

  @override
  Future<List<LottoWinPriceDto>> getWinPrices({required int drwNo}) async {
    List<LottoWinPriceDto> winPrices = [];
    final response = await http.get(
      Uri.parse('https://www.dhlottery.co.kr/gameResult.do?method=byWin&drwNo=$drwNo'),
    );
    if (response.statusCode != 200) return [];

    final decodedBody = await CharsetConverter.decode("euc-kr", response.bodyBytes);
    final document = html_parser.parse(decodedBody);
    final rows = document.querySelectorAll('.tbl_data_col tbody tr');
    for (final row in rows) {
      final cells = row.querySelectorAll('td');
      if (cells.length >= 4) {
        winPrices.add(LottoWinPriceDto(
          rank: cells[0].text.trim(),
          count: '${cells[2].text.trim()}명',
          price: cells[3].text.trim(),
          totalPrice: cells[1].text.trim(),
        ));
      }
    }

    return winPrices;
  }

  @override
  Future<void> saveLottoNumbers({required List<LottoDto> lottoNumbers}) async {
    final response = await Supabase.instance.client
        .from('lotto')
        .upsert(lottoNumbers.map((e) => e.toJson()).toList())
        .select();

    if (response.isEmpty) throw Exception('Lotto 저장 실패');
  }
}
