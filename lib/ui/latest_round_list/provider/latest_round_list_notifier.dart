import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:domain/repository/lotto_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LatestRoundListState {
  final List<LottoDto> lottoNumbers;

  LatestRoundListState({required this.lottoNumbers});

  factory LatestRoundListState.init() => LatestRoundListState(lottoNumbers: []);

  LatestRoundListState copyWith({List<LottoDto>? lottoNumbers}) {
    return LatestRoundListState(lottoNumbers: lottoNumbers ?? this.lottoNumbers);
  }
}

class LatestRoundListNotifier extends StateNotifier<LatestRoundListState> {
  final LottoRepository repository;

  LatestRoundListNotifier({required this.repository}) : super(LatestRoundListState.init());

  fetchLottoNumbers() async {
    state = state.copyWith(lottoNumbers: await repository.getLocalLottoNumbers());
  }
}
