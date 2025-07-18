import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LottoState {
  final LottoDto lottoDto;

  LottoState({required this.lottoDto});

  const LottoState.init({this.lottoDto = const LottoDto.init()});

  LottoState copyWith({LottoDto? lottoDto}) {
    return LottoState(lottoDto: lottoDto ?? this.lottoDto);
  }
}

class LottoNotifier extends StateNotifier<LottoState> {
  final LottoRepository repository;

  LottoNotifier({required this.repository}) : super(const LottoState.init());

  fetchLottoNumber() async {
    state = state.copyWith(lottoDto: await repository.getLottoNumber(drwNo: 1080));
  }
}
