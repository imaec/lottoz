import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoreState {
  final int maxRound;
  final List<LottoDto> lottoNumbers;
  final int statisticsSize;

  MoreState({required this.maxRound, required this.lottoNumbers, required this.statisticsSize});

  factory MoreState.init() => MoreState(maxRound: 20, lottoNumbers: [], statisticsSize: 20);

  MoreState copyWith({int? maxRound, List<LottoDto>? lottoNumbers, int? statisticsSize}) =>
      MoreState(
        maxRound: maxRound ?? this.maxRound,
        lottoNumbers: lottoNumbers ?? this.lottoNumbers,
        statisticsSize: statisticsSize ?? this.statisticsSize,
      );
}

class MoreNotifier extends StateNotifier<MoreState> {
  final LottoRepository lottoRepository;
  final SettingRepository settingRepository;

  MoreNotifier({required this.lottoRepository, required this.settingRepository})
    : super(MoreState.init());

  fetchStatisticsSize() async {
    final lottoNumbers = await lottoRepository.getLocalLottoNumbers();
    state = state.copyWith(
      maxRound: lottoNumbers.first.drwNo,
      lottoNumbers: lottoNumbers,
      statisticsSize: await settingRepository.getStatisticsSize(),
    );
  }

  updateStatisticsSize({required int statisticsSize}) async {
    state = state.copyWith(
      statisticsSize: await settingRepository.updateStatisticsSize(statisticsSize: statisticsSize),
    );
  }
}
