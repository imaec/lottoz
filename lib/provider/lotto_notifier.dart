import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LottoState {
  final LottoEvent? event;
  final List<LottoDto> lottoNumbers;
  final List<StoreDto> firstStores;

  LottoState({required this.event, required this.lottoNumbers, required this.firstStores});

  factory LottoState.init() => LottoState(event: null, lottoNumbers: [], firstStores: []);

  LottoState copyWith({
    LottoEvent? event,
    List<LottoDto>? lottoNumbers,
    List<StoreDto>? firstStores,
  }) {
    return LottoState(
      event: event ?? this.event,
      lottoNumbers: lottoNumbers ?? this.lottoNumbers,
      firstStores: firstStores ?? this.firstStores,
    );
  }
}

sealed class LottoEvent {}

class ShowInspectionDialog extends LottoEvent {
  final InspectionException exception;

  ShowInspectionDialog({required this.exception});
}

class ShowExceptionDialog extends LottoEvent {
  final Exception exception;

  ShowExceptionDialog({required this.exception});
}

class LottoNotifier extends StateNotifier<LottoState> {
  final LottoRepository repository;

  LottoNotifier({required this.repository}) : super(LottoState.init());

  fetchLottoNumber() async {
    final localCurDrwNo = await repository.getLocalCurDrwNo();
    final databaseCurDrwNo = await repository.getDatabaseCurDrwNo();
    int curDrwNo = databaseCurDrwNo;
    try {
      curDrwNo = await repository.getCurDrwNo();
    } on Exception catch (e) {
      if (e is InspectionException) {
        state = state.copyWith(event: ShowInspectionDialog(exception: e));
      } else {
        state = state.copyWith(event: ShowExceptionDialog(exception: e));
      }
    }

    final List<Future<dynamic>> futures = [];

    if (localCurDrwNo == curDrwNo && databaseCurDrwNo == curDrwNo) {
      futures.add(_fetchLottoNumbersFromLocal());
    } else if (databaseCurDrwNo != curDrwNo) {
      futures.add(
        _fetchLottoNumbersFromApi(curDrwNo: curDrwNo, databaseCurDrwNo: databaseCurDrwNo),
      );
    } else {
      futures.add(_fetchLottoNumbersFromDatabase(curDrwNo: curDrwNo));
    }
    futures.add(repository.getFirstStores(drwNo: curDrwNo));

    final results = await Future.wait(futures);

    state = state.copyWith(firstStores: results[1]);
  }

  _fetchLottoNumbersFromLocal() async {
    state = state.copyWith(lottoNumbers: await repository.getLocalLottoNumbers());
  }

  _fetchLottoNumbersFromApi({required int curDrwNo, required int databaseCurDrwNo}) async {
    final List<LottoDto> lottoNumbers = [];
    final drwNos = List.generate(curDrwNo - databaseCurDrwNo, (i) => curDrwNo - i);
    const chunkSize = 10;
    for (var i = 0; i < drwNos.length; i += chunkSize) {
      final chunk = drwNos.skip(i).take(chunkSize).toList();
      final chunkFutures = chunk.map((drwNo) => repository.getLottoNumber(drwNo: drwNo)).toList();
      final chunkResults = await Future.wait(chunkFutures);
      lottoNumbers.addAll(chunkResults);
    }
    lottoNumbers.sort((prevNumber, nextNumber) => nextNumber.drwNo.compareTo(prevNumber.drwNo));
    await Future.wait<dynamic>([
      repository.saveLottoNumbersDatabase(lottoNumbers: lottoNumbers),
      repository.saveLottoNumbersLocal(lottoNumbers: lottoNumbers),
      repository.setLocalCurDrwNo(curDrwNo: curDrwNo),
    ]);
    state = state.copyWith(lottoNumbers: await repository.getLocalLottoNumbers());
  }

  _fetchLottoNumbersFromDatabase({required int curDrwNo}) async {
    final lottoNumbers = await repository.getLottoNumbers();
    await Future.wait<dynamic>([
      repository.saveLottoNumbersLocal(lottoNumbers: lottoNumbers),
      repository.setLocalCurDrwNo(curDrwNo: curDrwNo),
    ]);
    state = state.copyWith(lottoNumbers: lottoNumbers);
  }

  clearEvent() {
    state = state.copyWith(event: null);
  }
}
