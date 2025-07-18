import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LottoState {
  final LottoDto lottoDto;
  final List<LottoDto> lottoNumbers;

  LottoState({required this.lottoDto, required this.lottoNumbers});

  const LottoState.init({this.lottoDto = const LottoDto.init(), this.lottoNumbers = const []});

  LottoState copyWith({LottoDto? lottoDto, List<LottoDto>? lottoNumbers}) {
    return LottoState(
      lottoDto: lottoDto ?? this.lottoDto,
      lottoNumbers: lottoNumbers ?? this.lottoNumbers,
    );
  }
}

class LottoNotifier extends StateNotifier<LottoState> {
  final LottoRepository repository;

  LottoNotifier({required this.repository}) : super(const LottoState.init());

  fetchLottoNumber() async {
    final localCurDrwNo = await repository.getLocalCurDrwNo();
    final curDrwNo = await repository.getCurDrwNo();
    await repository.setLocalCurDrwNo(curDrwNo);
    // todo : setWeek()

    // if (curDrwNo == localCurDrwNo) {
    //   // todo : fetchLottoNumbersFromFirebase()
    // } else {
    //   _fetchLottoNumbersFromApi(curDrwNo: curDrwNo, localCurDrwNo: localCurDrwNo);
    // }
    _fetchLottoNumbersFromApi(curDrwNo: curDrwNo, localCurDrwNo: localCurDrwNo);

    state = state.copyWith(lottoDto: await repository.getLottoNumber(drwNo: 1080));
  }

  _fetchLottoNumbersFromApi({required int curDrwNo, required int localCurDrwNo}) async {
    final List<LottoDto> lottoNumbers = [];
    final drwNoDiff = curDrwNo - localCurDrwNo;
    for (var drwNo = localCurDrwNo; drwNo <= curDrwNo; drwNo++) {
      final lottoDto = await repository.getLottoNumber(drwNo: drwNo);
      lottoNumbers.add(lottoDto);

      if (lottoNumbers.length == drwNoDiff + 1) {
        // todo : 모든 리스트 Local에 저장
        // saveLottoNumbers(lottoNumbers: tempNumbers);

        state = state.copyWith(
          lottoDto: lottoNumbers.first,
          lottoNumbers: lottoNumbers,
        );
      }
    }
  }
}
