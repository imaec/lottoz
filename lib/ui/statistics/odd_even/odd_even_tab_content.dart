part of '../statistics_screen.dart';

Widget _oddEvenTabContent({required StatisticsState statisticsState}) {
  final oddEvenStatistics = statisticsState.oddEvenStatistics;
  final totalOdd =
      (statisticsState.oddEvenStatistics.map((e) => e.oddNumbers.length).reduce((a, b) => a + b) /
              oddEvenStatistics.length)
          .toStringAsFixed(1);
  final totalEven =
      (statisticsState.oddEvenStatistics.map((e) => e.evenNumbers.length).reduce((a, b) => a + b) /
              oddEvenStatistics.length)
          .toStringAsFixed(1);

  return Column(
    children: [
      _statisticsHeader(
        rightWidget: Row(
          children: [
            const Text('홀짝 평균 ', style: bodyS),
            Text('$totalOdd : $totalEven', style: subtitle2),
          ],
        ),
      ),
      const HorizontalDivider(),
      Expanded(child: _oddEvenNumbers(oddEventNumbers: statisticsState.oddEvenStatistics)),
    ],
  );
}

Widget _oddEvenNumbers({required List<OddEvenStatisticsVo> oddEventNumbers}) {
  return ListView.builder(
    itemCount: oddEventNumbers.length,
    itemBuilder: (context, index) {
      final item = oddEventNumbers[index];

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
                    children: [
                      Row(
                        children: item.oddNumbers.mapIndexed((index, number) {
                          return Row(
                            children: [
                              const SizedBox(width: 6),
                              lottoNumber(number: number, numberType: NumberType.small),
                            ],
                          );
                        }).toList(),
                      ),
                      const SizedBox(width: 6),
                      const Text(' : ', style: bodyL),
                      Row(
                        children: item.evenNumbers.mapIndexed((index, number) {
                          return Row(
                            children: [
                              const SizedBox(width: 6),
                              lottoNumber(number: number, numberType: NumberType.small),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Text('${item.oddNumbers.length} : ${item.evenNumbers.length}', style: subtitle3),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ],
      );
    },
  );
}
