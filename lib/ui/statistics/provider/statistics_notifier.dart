import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:domain/repository/lotto_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottoz/model/statistics/statistics_range_vo.dart';
import 'package:lottoz/model/statistics/sum_statistics_vo.dart';
import 'package:lottoz/model/statistics/pick_statistics_vo.dart';
import 'package:lottoz/model/statistics/un_pick_statistics_vo.dart';
import 'package:lottoz/model/statistics/continuous_statistics_vo.dart';
import 'package:lottoz/model/statistics/odd_even_statistics_vo.dart';
import 'package:lottoz/model/statistics/win_statistics_vo.dart';

class StatisticsState {
  final List<LottoDto> lottoNumbers;
  final int sumAverage;
  final List<SumStatisticsVo> sumStatistics;
  final List<PickStatisticsVo> pickStatistics;
  final List<UnPickStatisticsVo> unPickStatistics;
  final List<ContinuousStatisticsVo> continuousStatistics;
  final List<OddEvenStatisticsVo> oddEvenStatistics;
  final WinStatisticsVo winStatistics;

  StatisticsState({
    required this.lottoNumbers,
    required this.sumAverage,
    required this.sumStatistics,
    required this.pickStatistics,
    required this.unPickStatistics,
    required this.continuousStatistics,
    required this.oddEvenStatistics,
    required this.winStatistics,
  });

  factory StatisticsState.init() => StatisticsState(
    lottoNumbers: [],
    sumAverage: 0,
    sumStatistics: [],
    pickStatistics: [],
    unPickStatistics: [],
    continuousStatistics: [],
    oddEvenStatistics: [],
    winStatistics: WinStatisticsVo.init(),
  );

  StatisticsState copyWith({
    List<LottoDto>? lottoNumbers,
    int? sumAverage,
    List<SumStatisticsVo>? sumStatistics,
    List<PickStatisticsVo>? pickStatistics,
    List<UnPickStatisticsVo>? unPickStatistics,
    List<ContinuousStatisticsVo>? continuousStatistics,
    List<OddEvenStatisticsVo>? oddEvenStatistics,
    WinStatisticsVo? winStatistics,
  }) {
    return StatisticsState(
      lottoNumbers: lottoNumbers ?? this.lottoNumbers,
      sumAverage: sumAverage ?? this.sumAverage,
      sumStatistics: sumStatistics ?? this.sumStatistics,
      pickStatistics: pickStatistics ?? this.pickStatistics,
      unPickStatistics: unPickStatistics ?? this.unPickStatistics,
      continuousStatistics: continuousStatistics ?? this.continuousStatistics,
      oddEvenStatistics: oddEvenStatistics ?? this.oddEvenStatistics,
      winStatistics: winStatistics ?? this.winStatistics,
    );
  }
}

class StatisticsNotifier extends StateNotifier<StatisticsState> {
  final LottoRepository repository;

  StatisticsNotifier({required this.repository}) : super(StatisticsState.init());

  fetchLottoNumber() async {
    final lottoNumbers = await repository.getLocalLottoNumbers();
    final sumAverage =
        lottoNumbers.map((lotto) => lotto.sum).reduce((a, b) => a + b) / lottoNumbers.length;
    final sumStatistics = _getSumStatistics(lottoNumbers: lottoNumbers);
    final pickStatistics = _getPickStatistics(lottoNumbers: lottoNumbers);
    final unPickStatistics = _getUnPickNumbers(lottoNumbers: lottoNumbers);
    final continuousStatistics = _getContinuousStatistics(lottoNumbers: lottoNumbers);
    final oddEvenStatistics = _getOddEvenStatistics(lottoNumbers: lottoNumbers);
    final winStatistics = _getWinStatistics(lottoNumbers: lottoNumbers.take(100).toList());

    state = state.copyWith(
      lottoNumbers: lottoNumbers,
      sumAverage: sumAverage.toInt(),
      sumStatistics: sumStatistics,
      pickStatistics: pickStatistics,
      unPickStatistics: unPickStatistics,
      continuousStatistics: continuousStatistics,
      oddEvenStatistics: oddEvenStatistics,
      winStatistics: winStatistics,
    );
  }

  List<SumStatisticsVo> _getSumStatistics({required List<LottoDto> lottoNumbers}) {
    final Map<String, int> countByRange = {};
    final Map<String, List<int>> sumByRange = {};
    final int totalCount = lottoNumbers.length;
    final List<StatisticsRangeVo> sumRanges = [
      StatisticsRangeVo(start: 21, end: 40),
      StatisticsRangeVo(start: 41, end: 60),
      StatisticsRangeVo(start: 61, end: 80),
      StatisticsRangeVo(start: 81, end: 100),
      StatisticsRangeVo(start: 101, end: 120),
      StatisticsRangeVo(start: 121, end: 140),
      StatisticsRangeVo(start: 141, end: 160),
      StatisticsRangeVo(start: 161, end: 180),
      StatisticsRangeVo(start: 181, end: 200),
      StatisticsRangeVo(start: 201, end: 220),
      StatisticsRangeVo(start: 221, end: 240),
      StatisticsRangeVo(start: 241, end: 260),
    ];
    List<SumStatisticsVo> sumStatistics = [];

    for (final range in sumRanges) {
      countByRange[range.range] = 0;
      sumByRange[range.range] = [];
    }

    for (final lotto in lottoNumbers) {
      for (final range in sumRanges) {
        if (range.isContains(lotto.sum)) {
          countByRange[range.range] = (countByRange[range.range] ?? 0) + 1;
          sumByRange[range.range]?.add(lotto.sum);
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

  List<PickStatisticsVo> _getPickStatistics({required List<LottoDto> lottoNumbers}) {
    final ranges = [
      StatisticsRangeVo(start: 1, end: 10),
      StatisticsRangeVo(start: 11, end: 20),
      StatisticsRangeVo(start: 21, end: 30),
      StatisticsRangeVo(start: 31, end: 40),
      StatisticsRangeVo(start: 41, end: 45),
    ];
    List<PickStatisticsVo> pickStatistics = [];

    final allNumbers = lottoNumbers.expand(
      (e) => [e.drwtNo1, e.drwtNo2, e.drwtNo3, e.drwtNo4, e.drwtNo5, e.drwtNo6],
    );

    for (final range in ranges) {
      final count = allNumbers.where((n) => range.isContains(n)).length;
      pickStatistics.add(PickStatisticsVo(range: range.range, count: count));
    }

    return pickStatistics;
  }

  List<UnPickStatisticsVo> _getUnPickNumbers({required List<LottoDto> lottoNumbers}) {
    final ranges = [
      StatisticsRangeVo(start: 1, end: 10),
      StatisticsRangeVo(start: 11, end: 20),
      StatisticsRangeVo(start: 21, end: 30),
      StatisticsRangeVo(start: 31, end: 40),
      StatisticsRangeVo(start: 41, end: 45),
    ];
    final Set<int> allNumbers = Set.from(List.generate(45, (i) => i + 1));
    final appeared = lottoNumbers
        .expand((e) => [e.drwtNo1, e.drwtNo2, e.drwtNo3, e.drwtNo4, e.drwtNo5, e.drwtNo6])
        .toSet();
    List<UnPickStatisticsVo> unPickStatistics = [];

    final Set<int> unPickNumbers = allNumbers.difference(appeared);

    for (final range in ranges) {
      unPickStatistics.add(
        UnPickStatisticsVo(
          range: range.range,
          numbers: unPickNumbers.where((n) => range.isContains(n)).toList()..sort(),
        ),
      );
    }

    return unPickStatistics;
  }

  List<ContinuousStatisticsVo> _getContinuousStatistics({required List<LottoDto> lottoNumbers}) {
    final continuousStatistics = lottoNumbers.map((lotto) {
      final continuousNumbers = _getContinuousNumbers(numbers: lotto.numbers);
      final description = _getContinuousDescription(continuousNumbers: continuousNumbers);
      return ContinuousStatisticsVo(
        round: '${lotto.drwNo}회',
        numbers: lotto.numbers,
        continuousNumbers: continuousNumbers,
        description: description,
      );
    }).toList();

    return continuousStatistics;
  }

  List<List<int>> _getContinuousNumbers({required List<int> numbers}) {
    if (numbers.isEmpty) return [];

    // 먼저 오름차순 정렬
    final sorted = [...numbers]..sort();
    final List<List<int>> result = [];
    List<int> current = [sorted.first];

    for (int i = 1; i < sorted.length; i++) {
      if (sorted[i] == sorted[i - 1] + 1) {
        current.add(sorted[i]);
      } else {
        if (current.length > 1) result.add([...current]);
        current = [sorted[i]];
      }
    }
    if (current.length > 1) result.add(current);

    return result;
  }

  String _getContinuousDescription({required List<List<int>> continuousNumbers}) {
    if (continuousNumbers.isEmpty) return '연속번호 없음';

    final Map<int, int> groupCount = {};
    for (final group in continuousNumbers) {
      groupCount[group.length] = (groupCount[group.length] ?? 0) + 1;
    }
    return groupCount.entries.map((e) => '${e.key}연속 ${e.value}개').join('\n');
  }

  List<OddEvenStatisticsVo> _getOddEvenStatistics({required List<LottoDto> lottoNumbers}) {
    final oddEvenStatistics = lottoNumbers.map((lotto) {
      final oddNumbers = lotto.numbers.where((number) => number.isOdd).toList();
      final evenNumbers = lotto.numbers.where((number) => number.isEven).toList();
      return OddEvenStatisticsVo(
        round: '${lotto.drwNo}회',
        oddNumbers: oddNumbers,
        evenNumbers: evenNumbers,
      );
    }).toList();

    return oddEvenStatistics;
  }

  WinStatisticsVo _getWinStatistics({required List<LottoDto> lottoNumbers}) {
    final roundCount = lottoNumbers.length;
    // 총 당첨금 평균
    final totalPriceAverage =
        lottoNumbers.fold<double>(0, (prev, e) => prev + e.firstAccumamnt) / roundCount;
    // 1게임 당첨금 평균
    final priceAverage =
        lottoNumbers.fold<double>(0, (prev, e) => prev + e.firstWinamnt) / roundCount;
    // 당참자 수 평균
    final winCountAverage = lottoNumbers.fold<int>(0, (p, e) => p + e.firstPrzwnerCo) / roundCount;
    // 1게임 최고 당첨금
    final maxTotalPriceDto = lottoNumbers.reduce(
          (a, b) => a.firstWinamnt > b.firstWinamnt ? a : b,
    );
    final maxTotalPriceRound = maxTotalPriceDto.drwNo;
    final maxTotalPrice = maxTotalPriceDto.firstWinamnt;
    // 1게임 최소 당첨금
    final minTotalPriceDto = lottoNumbers.reduce(
          (a, b) => a.firstWinamnt < b.firstWinamnt ? a : b,
    );
    final minTotalPriceRound = minTotalPriceDto.drwNo;
    final minTotalPrice = minTotalPriceDto.firstWinamnt;
    // 최대 당첨자 수
    final maxWinCountDto = lottoNumbers.reduce(
          (a, b) => a.firstPrzwnerCo > b.firstPrzwnerCo ? a : b,
    );
    final maxWinCountRound = maxWinCountDto.drwNo;
    final maxWinCount = maxWinCountDto.firstPrzwnerCo;
    // 최소 당첨자 수
    final minWinCountDto = lottoNumbers.reduce(
          (a, b) => a.firstPrzwnerCo < b.firstPrzwnerCo ? a : b,
    );
    final minWinCountRound = minWinCountDto.drwNo;
    final minWinCount = minWinCountDto.firstPrzwnerCo;

    return WinStatisticsVo(
      roundCount: lottoNumbers.length,
      totalPriceAverage: totalPriceAverage,
      priceAverage: priceAverage,
      winCountAverage: winCountAverage,
      maxTotalPriceRound: maxTotalPriceRound,
      maxTotalPrice: maxTotalPrice,
      minTotalPriceRound: minTotalPriceRound,
      minTotalPrice: minTotalPrice,
      maxWinCountRound: maxWinCountRound,
      maxWinCount: maxWinCount,
      minWinCountRound: minWinCountRound,
      minWinCount: minWinCount,
    );
  }
}
