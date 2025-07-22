import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:domain/model/lotto/lotto_win_price_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottoz/model/lotto/lotto_win_statistics_vo.dart';

class LottoDetailState {
  final bool isPricesLoading;
  final List<LottoWinPriceDto> winPrices;
  final bool isStatisticsLoading;
  final List<LottoWinStatisticsVo> winStatistics;
  final bool isFirstStoresLoading;
  final List<StoreDto> firstStores;
  final bool isSecondStoresLoading;
  final List<StoreDto> secondStores;

  LottoDetailState({
    required this.isPricesLoading,
    required this.winPrices,
    required this.isStatisticsLoading,
    required this.winStatistics,
    required this.isFirstStoresLoading,
    required this.firstStores,
    required this.isSecondStoresLoading,
    required this.secondStores,
  });

  factory LottoDetailState.init() => LottoDetailState(
    isPricesLoading: true,
    winPrices: [],
    isStatisticsLoading: true,
    winStatistics: [],
    isFirstStoresLoading: true,
    firstStores: [],
    isSecondStoresLoading: true,
    secondStores: [],
  );

  LottoDetailState copyWith({
    bool? isPricesLoading,
    List<LottoWinPriceDto>? winPrices,
    bool? isStatisticsLoading,
    List<LottoWinStatisticsVo>? winStatistics,
    bool? isFirstStoresLoading,
    List<StoreDto>? firstStores,
    bool? isSecondStoresLoading,
    List<StoreDto>? secondStores,
  }) => LottoDetailState(
    isPricesLoading: isPricesLoading ?? this.isPricesLoading,
    winPrices: winPrices ?? this.winPrices,
    isStatisticsLoading: isStatisticsLoading ?? this.isStatisticsLoading,
    winStatistics: winStatistics ?? this.winStatistics,
    isFirstStoresLoading: isFirstStoresLoading ?? this.isFirstStoresLoading,
    firstStores: firstStores ?? this.firstStores,
    isSecondStoresLoading: isSecondStoresLoading ?? this.isSecondStoresLoading,
    secondStores: secondStores ?? this.secondStores,
  );
}

class LottoDetailNotifier extends StateNotifier<LottoDetailState> {
  final LottoRepository repository;

  LottoDetailNotifier({required this.repository}) : super(LottoDetailState.init());

  fetchLottoDetail({required LottoDto lotto}) async {
    state = state.copyWith(isPricesLoading: true);
    final winPrices = await repository.getWinPrices(drwNo: lotto.drwNo);
    state = state.copyWith(isPricesLoading: false, winPrices: winPrices);

    await Future.wait([
      _fetchWinStatistics(lotto: lotto, secondCount: winPrices[1].count),
      _fetchStores(drwNo: lotto.drwNo),
    ]);
  }

  Future<void> _fetchWinStatistics({
    required LottoDto lotto,
    required String secondCount,
  }) async {
    state = state.copyWith(isStatisticsLoading: true);
    final lottoNumbers = await repository.getLocalLottoNumbers();
    // 총 판매액
    final totalSellAmountAverage =
        lottoNumbers.take(52).fold(0.0, (sum, lotto) => sum + lotto.totSellamnt) / 52;
    final sellAmountRate = 100 - (lotto.totSellamnt / totalSellAmountAverage * 100);
    final diffSellAmountText = sellAmountRate == 0.0
        ? '과 비슷합니다.'
        : sellAmountRate > 0.0
        ? '보다 ${sellAmountRate.toStringAsFixed(1)}% 낮습니다.'
        : '보다 ${sellAmountRate.abs().toStringAsFixed(1)}% 높습니다.';
    // 당첨
    final totalPriceAverage =
        lottoNumbers.take(52).fold(0.0, (sum, lotto) => sum + lotto.firstAccumamnt) / 52;
    final totalPriceRate = 100 - (lotto.firstAccumamnt / totalPriceAverage * 100);
    final diffTotalPriceText = totalPriceRate == 0.0
        ? '과 비슷하고.'
        : totalPriceRate > 0.0
        ? '보다 ${totalPriceRate.toStringAsFixed(1)}% 낮고,'
        : '보다 ${totalPriceRate.abs().toStringAsFixed(1)}% 높고,';
    final priceAverage =
        lottoNumbers.take(52).fold(0.0, (sum, lotto) => sum + lotto.firstWinamnt) / 52;
    final priceRate = 100 - (lotto.firstWinamnt / priceAverage * 100);
    final diffPriceText = priceRate == 0.0
        ? '과 비슷합니다.'
        : priceRate > 0.0
        ? '보다 ${priceRate.toStringAsFixed(1)}% 낮습니다.'
        : '보다 ${priceRate.abs().toStringAsFixed(1)}% 높습니다.';
    final winCountText = _getWinCountText(
      winCount: lotto.firstPrzwnerCo,
      secondWinCount: int.parse(secondCount.replaceAll('명', '')),
      totalSellAmount: lotto.totSellamnt.toInt(),
    );
    // 합계
    final sum = lotto.numbers.fold(0, (sum, number) => sum + number);
    final sumAverage =
        (lottoNumbers.fold(
                  0,
                  (sum, lotto) => sum + lotto.numbers.fold(0, (sum, number) => sum + number),
                ) /
                lottoNumbers.length)
            .round();
    final diffSum = sumAverage - sum;
    final diffSumText = diffSum >= -15 && diffSum <= 15
        ? '하고 비슷합니다.'
        : diffSum > 15
        ? '보다 $diffSum 낮습니다.'
        : '보다 ${diffSum.abs()} 높습니다.';

    final List<LottoWinStatisticsVo> winStatistics = [
      LottoWinStatisticsVo(
        title: '총 판매액',
        content:
            ' 이번주 총 판매액은 ${lotto.totSellamnt.toWon()}으로 '
            '최근 1년 총 판매액 평균인 ${totalSellAmountAverage.toWon()}$diffSellAmountText',
      ),
      LottoWinStatisticsVo(
        title: '당첨',
        content:
            ' 이번주 1등 총 당첨금은 ${lotto.firstAccumamnt.toWon()}으로 최근 1년 1등 총 당첨금 평균인 '
            '${totalPriceAverage.toWon()}$diffTotalPriceText 1게임 당첨금은 '
            '${lotto.firstWinamnt.toWon()}으로 최근 1년 1게임 당첨금 평균인 '
            '${priceAverage.toWon()}$diffPriceText\n\n$winCountText',
      ),
      LottoWinStatisticsVo(
        title: '합계',
        content: ' 이번주 당첨 번호 합계는 $sum이고, 전체 회차 합계 평균인 $sumAverage$diffSumText',
      ),
    ];

    state = state.copyWith(
      isStatisticsLoading: false,
      winStatistics: winStatistics,
    );
  }

  String _getWinCountText({
    required int winCount,
    required int secondWinCount,
    required int totalSellAmount,
  }) {
    const int lottoPrice = 1000;
    final int totalGames = totalSellAmount ~/ lottoPrice;

    const double probFirst = 1 / 8145060;
    const double probSecond = 1 / 1357510;

    final double expectedFirst = totalGames * probFirst;
    final double expectedSecond = totalGames * probSecond;

    final double firstDiffPercent = ((winCount - expectedFirst) / expectedFirst) * 100;
    final double secondDiffPercent = ((secondWinCount - expectedSecond) / expectedSecond) * 100;

    String formatDiff(double percent) {
      final rounded = percent.toStringAsFixed(1);
      return percent >= 0 ? '$rounded% 높은 수치' : '${rounded.replaceFirst('-', '')}% 낮은 수치';
    }

    return ' 1등 당첨자 수는 $winCount명으로, 이는 1등 당첨 기대치 ${expectedFirst.round()}명(확률 1/814만)보다 ${formatDiff(firstDiffPercent)}입니다.\n'
        ' 2등 당첨자 수는 $secondWinCount명으로, 이는 2등 당첨 기대치 ${expectedSecond.round()}명(확률 1/135만)보다 ${formatDiff(secondDiffPercent)}입니다.';
  }

  Future<void> _fetchStores({required int drwNo}) async {
    await Future.wait([
      _fetchFirstStores(drwNo: drwNo),
      _fetchSecondStores(drwNo: drwNo),
    ]);
  }

  Future<void> _fetchFirstStores({required int drwNo}) async {
    state = state.copyWith(isFirstStoresLoading: true);
    final stores = await repository.getFirstStores(drwNo: drwNo);
    state = state.copyWith(
      isFirstStoresLoading: false,
      firstStores: stores,
    );
  }

  Future<void> _fetchSecondStores({required int drwNo}) async {
    state = state.copyWith(isSecondStoresLoading: true);
    final stores = await repository.getSecondStores(drwNo: drwNo);
    state = state.copyWith(
      isSecondStoresLoading: false,
      secondStores: stores,
    );
  }
}
