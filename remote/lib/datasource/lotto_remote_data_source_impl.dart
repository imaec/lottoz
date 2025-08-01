import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:charset_converter/charset_converter.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:domain/model/lotto/lotto_win_price_dto.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
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
    final uri = Uri.parse('https://www.dhlottery.co.kr/common.do?method=main&mainMode=default');
    final request = await HttpClient().getUrl(uri);
    final response = await request.close();

    final document = await _parsingHtml(response: response);
    if (document == null) return 0;

    try {
      final curDrwNo = int.parse(document.getElementById('lottoDrwNo')?.text ?? '');
      return curDrwNo;
    } catch (e) {
      throw await _inspectionException(uri: uri) ?? e;
    }
  }

  @override
  Future<int> getDatabaseCurDrwNo() async {
    final response = await Supabase.instance.client
        .from('lotto')
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
    final uri = Uri.parse('https://www.dhlottery.co.kr/store.do?method=topStore&pageGubun=L645');
    final request = await HttpClient().postUrl(uri)
      ..write({'gameNo': '5133', 'drwNo': '$drwNo'});
    final response = await request.close();

    final document = await _parsingHtml(response: response);
    if (document == null) return [];

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
      final uri = Uri.parse('https://www.dhlottery.co.kr/store.do?method=topStore&pageGubun=L645');
      final request = await HttpClient().postUrl(uri)
        ..write({'gameNo': '5133', 'drwNo': '$drwNo', 'rank': '2', 'nowPage': page.toString()});
      final response = await request.close();

      final document = await _parsingHtml(response: response);
      if (document == null) break;

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
    final request = await HttpClient().postUrl(uri)
      ..write({'rank': '2', 'nowPage': '1'});
    final response = await request.close();

    final document = await _parsingHtml(response: response);
    if (document == null) return 1;

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
    final uri = Uri.parse('https://www.dhlottery.co.kr/gameResult.do?method=byWin&drwNo=$drwNo');
    final request = await HttpClient().getUrl(uri);
    final response = await request.close();

    final document = await _parsingHtml(response: response);
    if (document == null) return [];

    final rows = document.querySelectorAll('.tbl_data_col tbody tr');

    for (final row in rows) {
      final cells = row.querySelectorAll('td');
      if (cells.length >= 4) {
        winPrices.add(
          LottoWinPriceDto(
            rank: cells[0].text.trim(),
            count: '${cells[2].text.trim()}명',
            price: cells[3].text.trim(),
            totalPrice: cells[1].text.trim(),
          ),
        );
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

  Future<dom.Document?> _parsingHtml({required HttpClientResponse response}) async {
    if (response.statusCode != 200) return null;

    final contentType = response.headers.contentType;
    final charset = contentType?.charset?.toLowerCase() ?? 'utf-8';
    final bytes = await response.fold<List<int>>([], (prev, element) => prev..addAll(element));
    late final String responseBody;
    if (charset == 'euc-kr') {
      responseBody = await CharsetConverter.decode('euc-kr', Uint8List.fromList(bytes));
    } else {
      responseBody = await CharsetConverter.decode('utf-8', Uint8List.fromList(bytes));
    }

    final document = html_parser.parse(responseBody);
    return document;
  }

  _inspectionException({required Uri uri}) async {
    final client = HttpClient();
    final request = await client.getUrl(uri);
    final newResponse = await request.close();
    final responseBody = await newResponse.transform(utf8.decoder).join();
    client.close();

    final document = html_parser.parse(responseBody);
    final title = document.getElementsByTagName('title').first.text;

    if (title.contains('시스템 점검')) {
      final listItems = document.querySelectorAll('.check_list_bx ul li');
      String? content;
      String? time;

      for (var li in listItems) {
        final text = li.text.trim();
        if (text.contains('점검내용')) {
          content = text.replaceFirst('점검내용 : ', '').trim();
        } else if (text.contains('점검시간')) {
          time = text.replaceFirst('점검시간 : ', '').trim();
        }
      }

      throw InspectionException(content: '점검내용 : $content', time: '점검시간 : $time');
    }
  }
}
