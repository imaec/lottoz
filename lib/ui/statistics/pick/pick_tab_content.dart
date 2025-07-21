part of '../statistics_screen.dart';

Widget _pickTabContent({required StatisticsNotifier notifier, required StatisticsState state}) {
  return Column(
    children: [
      _statisticsHeader(
        notifier: notifier,
        startRound: state.startRound,
        endRound: state.endRound,
        maxRound: state.maxRound,
      ),
      const HorizontalDivider(),
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _pickCounts(pickStatistics: state.pickStatistics),
              const HorizontalDivider(),
              _unPickNumbers(unPickStatistics: state.unPickStatistics),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _pickCounts({required List<PickStatisticsVo> pickStatistics}) {
  final maxCount = pickStatistics.map((pick) => pick.count).reduce((a, b) => a > b ? a : b);

  // todo : 번호별 출현 횟수 추가
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('구간별 출현 횟수', style: subtitle2),
        ),
        const SizedBox(height: 12),
        Column(
          children: pickStatistics.map((pick) {
            return Row(
              children: [
                SizedBox(
                  width: 65,
                  child: Text(pick.range, style: bodyS, textAlign: TextAlign.center),
                ),
                Container(height: 40, width: 1, color: gray100),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: TweenAnimationBuilder(
                          tween: Tween(begin: 0.0, end: pick.count / maxCount),
                          duration: const Duration(milliseconds: 600),
                          builder: (context, value, child) {
                            return FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: value,
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: getLottoColor(
                                    number: int.parse(pick.range.split('-').first),
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(4),
                                    bottomRight: Radius.circular(4),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text('${pick.count}', style: subtitle3),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    ),
  );
}

Widget _unPickNumbers({required List<UnPickStatisticsVo> unPickStatistics}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('구간별 미출현 번호', style: subtitle2),
        ),
        const SizedBox(height: 12),
        Column(
          children: unPickStatistics.map((statistics) {
            return Row(
              children: [
                SizedBox(
                  width: 65,
                  child: Text(statistics.range, style: bodyS, textAlign: TextAlign.center),
                ),
                Container(height: 40, width: 1, color: gray100),
                Expanded(
                  child: Row(
                    children: statistics.numbers.mapIndexed((index, number) {
                      return Row(
                        children: [
                          SizedBox(width: index < statistics.numbers.length ? 8 : 0),
                          lottoNumber(number: number),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    ),
  );
}
