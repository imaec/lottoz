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
    final firebaseCurDrwNo = await repository.getFirebaseCurDrwNo();
    final curDrwNo = await repository.getCurDrwNo();

    if (localCurDrwNo == curDrwNo && firebaseCurDrwNo == curDrwNo) {
      await _fetchLottoNumbersFromDatabase();
    } else if (firebaseCurDrwNo != curDrwNo) {
      await _fetchLottoNumbersFromApi(curDrwNo: curDrwNo, firebaseCurDrwNo: firebaseCurDrwNo);
    } else {
      await _fetchLottoNumbersFromFirebase(curDrwNo: curDrwNo);
    }

    state = state.copyWith(stores: await repository.getStores(drwNo: curDrwNo));
  }

  _fetchLottoNumbersFromDatabase() async {
    state = state.copyWith(lottoNumbers: await repository.getLocalLottoNumbers());
  }

  _fetchLottoNumbersFromApi({required int curDrwNo, required int firebaseCurDrwNo}) async {
    final List<LottoDto> lottoNumbers = [];
    final drwNos = List.generate(curDrwNo - firebaseCurDrwNo, (i) => curDrwNo - i);
    const chunkSize = 10;
    for (var i = 0; i < drwNos.length; i += chunkSize) {
      final chunk = drwNos.skip(i).take(chunkSize).toList();
      final chunkFutures = chunk.map((drwNo) => repository.getLottoNumber(drwNo: drwNo)).toList();
      final chunkResults = await Future.wait(chunkFutures);
      lottoNumbers.addAll(chunkResults);
    }
    lottoNumbers.sort((prevNumber, nextNumber) => nextNumber.drwNo.compareTo(prevNumber.drwNo));
    await Future.wait<dynamic>([
      repository.saveLottoNumbersFirebase(lottoNumbers: lottoNumbers),
      repository.saveLottoNumbersLocal(lottoNumbers: lottoNumbers),
      repository.setFirebaseCurDrwNo(curDrwNo: curDrwNo),
      repository.setLocalCurDrwNo(curDrwNo: curDrwNo),
    ]);
    state = state.copyWith(lottoNumbers: await repository.getLocalLottoNumbers());
  }

  _fetchLottoNumbersFromFirebase({required int curDrwNo}) async {
    final lottoNumbers = await repository.getFirebaseLottoNumbers();
    await Future.wait<dynamic>([
      repository.saveLottoNumbersLocal(lottoNumbers: lottoNumbers),
      repository.setLocalCurDrwNo(curDrwNo: curDrwNo),
    ]);
    state = state.copyWith(lottoNumbers: lottoNumbers);
  }
}
