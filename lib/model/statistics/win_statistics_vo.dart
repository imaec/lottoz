class WinStatisticsVo {
  final int roundCount;
  final double totalPriceAverage;
  final double priceAverage;
  final double winCountAverage;
  final int maxTotalPriceRound;
  final int maxTotalPrice;
  final int minTotalPriceRound;
  final int minTotalPrice;
  final int maxWinCountRound;
  final int maxWinCount;
  final int minWinCountRound;
  final int minWinCount;

  WinStatisticsVo({
    required this.roundCount,
    required this.totalPriceAverage,
    required this.priceAverage,
    required this.winCountAverage,
    required this.maxTotalPriceRound,
    required this.maxTotalPrice,
    required this.minTotalPriceRound,
    required this.minTotalPrice,
    required this.maxWinCountRound,
    required this.maxWinCount,
    required this.minWinCountRound,
    required this.minWinCount,
  });

  factory WinStatisticsVo.init() => WinStatisticsVo(
    roundCount: 0,
    totalPriceAverage: 0,
    priceAverage: 0,
    winCountAverage: 0,
    maxTotalPriceRound: 0,
    maxTotalPrice: 0,
    minTotalPriceRound: 0,
    minTotalPrice: 0,
    maxWinCountRound: 0,
    maxWinCount: 0,
    minWinCountRound: 0,
    minWinCount: 0,
  );
}
