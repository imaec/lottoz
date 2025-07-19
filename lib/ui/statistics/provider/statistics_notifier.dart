import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:domain/repository/lotto_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottoz/model/statistics/sum_range_vo.dart';
import 'package:lottoz/model/statistics/sum_statistics_vo.dart';

class StatisticsState {
  final List<LottoDto> lottoNumbers;
  final int sumAverage;
  final List<SumStatisticsVo> sumStatistics;

  StatisticsState({
    required this.lottoNumbers,
    required this.sumAverage,
    required this.sumStatistics,
  });

  const StatisticsState.init({
    this.lottoNumbers = const [],
    this.sumAverage = 0,
    this.sumStatistics = const [],
  });

  StatisticsState copyWith({
    List<LottoDto>? lottoNumbers,
    int? sumAverage,
    List<SumStatisticsVo>? sumStatistics,
  }) {
    return StatisticsState(
      lottoNumbers: lottoNumbers ?? this.lottoNumbers,
      sumAverage: sumAverage ?? this.sumAverage,
      sumStatistics: sumStatistics ?? this.sumStatistics,
    );
  }
}

class StatisticsNotifier extends StateNotifier<StatisticsState> {
  final LottoRepository repository;

  StatisticsNotifier({required this.repository}) : super(const StatisticsState.init());

  fetchLottoNumber() async {
    final lottoNumbers = await repository.getLocalLottoNumbers();
    final sumAverage =
        lottoNumbers.map((lotto) => lotto.getSum()).reduce((a, b) => a + b) / lottoNumbers.length;
    final sumStatistics = _getSumStatistics(lottoNumbers: lottoNumbers);

    state = state.copyWith(
      lottoNumbers: lottoNumbers,
      sumAverage: sumAverage.toInt(),
      sumStatistics: sumStatistics,
    );
  }

  List<SumStatisticsVo> _getSumStatistics({required List<LottoDto> lottoNumbers}) {
    final Map<String, int> countByRange = {};
    final Map<String, List<int>> sumByRange = {};
    final int totalCount = lottoNumbers.length;
    final List<SumRangeVo> sumRanges = [
      SumRangeVo(start: 21, end: 40),
      SumRangeVo(start: 41, end: 60),
      SumRangeVo(start: 61, end: 80),
      SumRangeVo(start: 81, end: 100),
      SumRangeVo(start: 101, end: 120),
      SumRangeVo(start: 121, end: 140),
      SumRangeVo(start: 141, end: 160),
      SumRangeVo(start: 161, end: 180),
      SumRangeVo(start: 181, end: 200),
      SumRangeVo(start: 201, end: 220),
      SumRangeVo(start: 221, end: 240),
      SumRangeVo(start: 241, end: 260),
    ];
    List<SumStatisticsVo> sumStatistics = [];

    for (final range in sumRanges) {
      countByRange['${range.start}-${range.end}'] = 0;
      sumByRange['${range.start}-${range.end}'] = [];
    }

    for (final lotto in lottoNumbers) {
      final sum = lotto.getSum();
      for (final range in sumRanges) {
        if (range.isContains(sum)) {
          countByRange['${range.start}-${range.end}'] =
              (countByRange['${range.start}-${range.end}'] ?? 0) + 1;
          sumByRange['${range.start}-${range.end}']?.add(sum);
          break;
        }
      }
    }

    for (final sumRanges in sumRanges) {
      final range = '${sumRanges.start}-${sumRanges.end}';
      final count = countByRange[range] ?? 0;
      final rate = totalCount > 0 ? (count / totalCount * 100) : 0.0;
      final rateString = '${rate.toStringAsFixed(1)}%';
      sumStatistics.add(SumStatisticsVo(range: range, count: count, rate: rateString));
    }

    return sumStatistics;
  }
}
