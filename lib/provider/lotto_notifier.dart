import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LottoState {
  final List<LottoDto> lottoNumbers;
  final List<StoreDto> stores;

  LottoState({required this.lottoNumbers, required this.stores});

  const LottoState.init({this.lottoNumbers = const [], this.stores = const []});

  LottoState copyWith({List<LottoDto>? lottoNumbers, List<StoreDto>? stores}) {
    return LottoState(
      lottoNumbers: lottoNumbers ?? this.lottoNumbers,
      stores: stores ?? this.stores,
    );
  }
}

class LottoNotifier extends StateNotifier<LottoState> {
  final LottoRepository repository;

  LottoNotifier({required this.repository}) : super(const LottoState.init());

  fetchLottoNumber() async {
    final localCurDrwNo = await repository.getLocalCurDrwNo();
    final curDrwNo = await repository.getCurDrwNo();
    await repository.setLocalCurDrwNo(curDrwNo: curDrwNo);

    if (curDrwNo == localCurDrwNo) {
      await _fetchLottoNumbersFromDatabase();
    } else {
      await _fetchLottoNumbersFromApi(curDrwNo: curDrwNo, localCurDrwNo: localCurDrwNo);
    }
    state = state.copyWith(stores: await repository.getStores(drwNo: curDrwNo));
  }

  _fetchLottoNumbersFromDatabase() async {
    state = state.copyWith(lottoNumbers: await repository.getLottoNumbers());
  }

  _fetchLottoNumbersFromApi({required int curDrwNo, required int localCurDrwNo}) async {
    final List<LottoDto> lottoNumbers = [];
    final drwNoDiff = curDrwNo - localCurDrwNo;
    for (var drwNo = localCurDrwNo; drwNo <= curDrwNo; drwNo++) {
      final lottoDto = await repository.getLottoNumber(drwNo: drwNo);
      lottoNumbers.add(lottoDto);

      if (lottoNumbers.length == drwNoDiff + 1) {
        await repository.saveLottoNumbers(lottoNumbers: lottoNumbers);

        state = state.copyWith(lottoNumbers: lottoNumbers);
      }
    }
  }
}
