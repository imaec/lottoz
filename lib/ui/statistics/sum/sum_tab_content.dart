part of '../statistics_screen.dart';

Widget _sumTabContent({required StatisticsNotifier notifier, required StatisticsState state}) {
  return Column(
    children: [
      _statisticsHeader(
        notifier: notifier,
        startRound: state.startRound,
        endRound: state.endRound,
        maxRound: state.maxRound,
        rightWidget: Row(
          children: [
            Text('${state.lottoNumbers.length}회 합계 평균 : ', style: bodyS),
            Text('${state.sumAverage}', style: subtitle2),
          ],
        ),
      ),
      _sumTabGraphHeader(),
      Expanded(child: _sumTabGraph(sumStatistics: state.sumStatistics)),
    ],
  );
}

Widget _sumTabGraphHeader() {
  return Container(
    color: gray700,
    child: Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '합계',
            style: bodyS.copyWith(color: white),
            textAlign: TextAlign.center,
          ),
        ),
        Container(height: 40, width: 1, color: gray100),
        Expanded(
          child: Text(
            '횟수',
            style: bodyS.copyWith(color: white),
            textAlign: TextAlign.center,
          ),
        ),
        Container(height: 40, width: 1, color: gray100),
        SizedBox(
          width: 60,
          child: Text(
            '비율',
            style: bodyS.copyWith(color: white),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

Widget _sumTabGraph({required List<SumStatisticsVo> sumStatistics}) {
  final maxCount = sumStatistics.map((sum) => sum.count).reduce((a, b) => a > b ? a : b);

  return SingleChildScrollView(
    child: Column(
      children: sumStatistics.map((sum) {
        return Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(sum.range, style: bodyS, textAlign: TextAlign.center),
                ),
                Container(height: 40, width: 1, color: gray100),
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: TweenAnimationBuilder(
                          tween: Tween(begin: 0.0, end: sum.count / maxCount),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                          builder: (context, value, child) {
                            return FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: value,
                              child: Container(
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: graphBlue,
                                  borderRadius: BorderRadius.only(
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
                      Text('${sum.count}', style: subtitle3),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
                Container(height: 40, width: 1, color: gray100),
                SizedBox(
                  width: 60,
                  child: Text(sum.rate, style: bodyS, textAlign: TextAlign.center),
                ),
              ],
            ),
            const HorizontalDivider(),
          ],
        );
      }).toList(),
    ),
  );
}
