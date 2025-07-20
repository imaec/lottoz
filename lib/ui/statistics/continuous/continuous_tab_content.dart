part of '../statistics_screen.dart';

Widget _continuousTabContent({required StatisticsState statisticsState}) {
  return Column(
    children: [
      _statisticsHeader(),
      const HorizontalDivider(),
      Expanded(
        child: _continuousNumbers(continuousStatistics: statisticsState.continuousStatistics),
      ),
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
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                ),
                const SizedBox(width: 16),
                Text(item.description, style: subtitle3),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ],
      );
    },
  );
}
