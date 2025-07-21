part of '../statistics_screen.dart';

Widget _continuousTabContent({
  required StatisticsNotifier notifier,
  required StatisticsState state,
}) {
  return Column(
    children: [
      _statisticsHeader(
        notifier: notifier,
        startRound: state.startRound,
        endRound: state.endRound,
        maxRound: state.maxRound,
      ),
      const HorizontalDivider(),
      Expanded(child: _continuousNumbers(continuousStatistics: state.continuousStatistics)),
    ],
  );
}

Widget _continuousNumbers({required List<ContinuousStatisticsVo> continuousStatistics}) {
  return ListView.builder(
    itemCount: continuousStatistics.length,
    itemBuilder: (context, index) {
      final item = continuousStatistics[index];
      final continuousSet = item.continuousNumbers.expand((group) => group).toSet();

      return Row(
        children: [
          SizedBox(
            width: 65,
            child: Text(item.round, style: bodyS, textAlign: TextAlign.center),
          ),
          Container(height: 50, width: 1, color: gray100),
          Expanded(
            child: Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: item.numbers.mapIndexed((index, number) {
                    final isContinuous = continuousSet.contains(number);

                    return Row(
                      children: [
                        const SizedBox(width: 6),
                        lottoNumber(
                          number: number,
                          numberType: NumberType.small,
                          numberColor: isContinuous ? null : gray700,
                          backgroundColor: isContinuous
                              ? getLottoColor(number: number)
                              : Colors.transparent,
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(width: 6),
                Container(height: 50, width: 1, color: gray100),
                Expanded(
                  child: Text(item.description, style: subtitle3, textAlign: TextAlign.end),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      );
    },
  );
}
