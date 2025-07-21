import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:domain/repository/lotto_repository.dart';
import 'package:domain/repository/setting_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottoz/model/statistics/continuous_statistics_vo.dart';
import 'package:lottoz/model/statistics/odd_even_statistics_vo.dart';
import 'package:lottoz/model/statistics/pick_statistics_vo.dart';
import 'package:lottoz/model/statistics/statistics_range_vo.dart';
import 'package:lottoz/model/statistics/sum_statistics_vo.dart';
import 'package:lottoz/model/statistics/un_pick_statistics_vo.dart';
import 'package:lottoz/model/statistics/win_statistics_vo.dart';

class StatisticsState {
  final int startRound;
  final int endRound;
  final int maxRound;
  final List<LottoDto> localLottoNumbers;
  final List<LottoDto> lottoNumbers;
  final int sumAverage;
  final List<SumStatisticsVo> sumStatistics;
  final List<PickStatisticsVo> pickStatistics;
  final List<UnPickStatisticsVo> unPickStatistics;
  final List<ContinuousStatisticsVo> continuousStatistics;
  final List<OddEvenStatisticsVo> oddEvenStatistics;
  final WinStatisticsVo winStatistics;

  StatisticsState({
    required this.startRound,
    required this.endRound,
    required this.maxRound,
    required this.localLottoNumbers,
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
    startRound: 1,
    endRound: 1,
    maxRound: 1,
    localLottoNumbers: [],
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
    int? startRound,
    int? endRound,
    int? maxRound,
    List<LottoDto>? localLottoNumbers,
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
      startRound: startRound ?? this.startRound,
      endRound: endRound ?? this.endRound,
      maxRound: maxRound ?? this.maxRound,
      localLottoNumbers: localLottoNumbers ?? this.localLottoNumbers,
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
  final LottoRepository lottoRepository;
  final SettingRepository settingRepository;

  StatisticsNotifier({required this.lottoRepository, required this.settingRepository})
    : super(StatisticsState.init());

  fetchLottoNumber() async {
    final statisticsSize = await _getStatisticsSize();
    final localLottoNumbers = await lottoRepository.getLocalLottoNumbers();
    final endRound = localLottoNumbers.first.drwNo;
    final startRound = endRound - (statisticsSize - 1);


    _statistics(
      localLottoNumbers: localLottoNumbers,
      startRound: startRound,
      endRound: endRound,
    );
  }

  Future<int> _getStatisticsSize() async {
    return await settingRepository.getStatisticsSize();
  }

  List<SumStatisticsVo> _getSumStatistics({required List<LottoDto> lottoNumbers}) {
    final sumRanges = StatisticsRangeVo.sumRanges;
    final Map<String, int> countByRange = {};
    final Map<String, List<int>> sumByRange = {};
    final int totalCount = lottoNumbers.length;
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
    final pickRanges = StatisticsRangeVo.pickRanges;
    List<PickStatisticsVo> pickStatistics = [];

    final allNumbers = lottoNumbers.expand(
      (e) => [e.drwtNo1, e.drwtNo2, e.drwtNo3, e.drwtNo4, e.drwtNo5, e.drwtNo6],
    );

    for (final range in pickRanges) {
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

    // 오름차순 정렬
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
    final maxTotalPriceDto = lottoNumbers.reduce((a, b) => a.firstWinamnt > b.firstWinamnt ? a : b);
    final maxTotalPriceRound = maxTotalPriceDto.drwNo;
    final maxTotalPrice = maxTotalPriceDto.firstWinamnt;
    // 1게임 최소 당첨금
    final minTotalPriceDto = lottoNumbers.reduce((a, b) => a.firstWinamnt < b.firstWinamnt ? a : b);
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

  setStartRound({required int startRound}) {
    _statistics(
      localLottoNumbers: state.localLottoNumbers,
      startRound: startRound,
      endRound: state.endRound,
    );
  }

  setEndRound({required int endRound}) {
    _statistics(
      localLottoNumbers: state.localLottoNumbers,
      startRound: state.startRound,
      endRound: endRound,
    );
  }

  _statistics({
    required List<LottoDto> localLottoNumbers,
    required int startRound,
    required int endRound,
  }) {
    final lottoNumbers = localLottoNumbers
        .sublist(localLottoNumbers.length - endRound, localLottoNumbers.length - (startRound - 1))
        .toList();

    final sumAverage =
        lottoNumbers.map((lotto) => lotto.sum).reduce((a, b) => a + b) / lottoNumbers.length;
    final sumStatistics = _getSumStatistics(lottoNumbers: lottoNumbers);
    final pickStatistics = _getPickStatistics(lottoNumbers: lottoNumbers);
    final unPickStatistics = _getUnPickNumbers(lottoNumbers: lottoNumbers);
    final continuousStatistics = _getContinuousStatistics(lottoNumbers: lottoNumbers);
    final oddEvenStatistics = _getOddEvenStatistics(lottoNumbers: lottoNumbers);
    final winStatistics = _getWinStatistics(lottoNumbers: lottoNumbers.take(100).toList());

    state = state.copyWith(
      startRound: startRound,
      endRound: endRound,
      maxRound: localLottoNumbers.first.drwNo,
      localLottoNumbers: localLottoNumbers,
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
}
