part of '../statistics_screen.dart';

Widget _winTabContent({required StatisticsState statisticsState}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _statisticsHeader(),
      const HorizontalDivider(),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _winAverages(winStatistics: statisticsState.winStatistics),
            const HorizontalDivider(),
            _winStatistics(winStatistics: statisticsState.winStatistics),
          ],
        ),
      ),
    ],
  );
}

Widget _winAverages({required WinStatisticsVo winStatistics}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('1등 당첨 평균 (${winStatistics.roundCount}회)', style: subtitle2),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _winContent(
              subject: '총 당첨금',
              content:
                  '${winStatistics.totalPriceAverage.comma()} '
                  '(약 ${winStatistics.totalPriceAverage.to100Million()}억)',
            ),
            const SizedBox(height: 16),
            _winContent(
              subject: '1게임 당첨금',
              content:
                  '${winStatistics.priceAverage.comma()} '
                  '(약 ${winStatistics.priceAverage.to100Million()}억)',
            ),
            const SizedBox(height: 16),
            _winContent(
              subject: '당첨자 수',
              content: '${winStatistics.winCountAverage.toStringAsFixed(1)}명',
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _winStatistics({required WinStatisticsVo winStatistics}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('1등 당첨 통계 (${winStatistics.roundCount}회)', style: subtitle2),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _winContent(
              subject: '1게임 최고 당첨금',
              content:
                  '[${winStatistics.maxTotalPriceRound}회] '
                  '${winStatistics.maxTotalPrice.comma()} '
                  '(약 ${winStatistics.maxTotalPrice.to100Million()}억)',
            ),
            const SizedBox(height: 16),
            _winContent(
              subject: '1게임 최소 당첨금',
              content:
                  '[${winStatistics.minTotalPriceRound}회] '
                  '${winStatistics.minTotalPrice.comma()} '
                  '(약 ${winStatistics.minTotalPrice.to100Million()}억)',
            ),
            const SizedBox(height: 16),
            _winContent(
              subject: '최대 당첨자 수',
              content:
                  '[${winStatistics.maxWinCountRound}회] '
                  '${winStatistics.maxWinCount}명',
            ),
            const SizedBox(height: 16),
            _winContent(
              subject: '최소 당첨자 수',
              content:
                  '[${winStatistics.minWinCountRound}회] '
                  '${winStatistics.minWinCount}명',
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _winContent({required String subject, required String content}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(subject, style: bodyS.copyWith(color: gray600)),
      Text(content, style: bodyM),
    ],
  );
}
