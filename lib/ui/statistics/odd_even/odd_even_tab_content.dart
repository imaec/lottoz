part of '../statistics_screen.dart';

Widget _oddEvenTabContent() {
  final lottoNumbers = [
    LottoVo(round: '1180회', numbers: [6, 12, 18, 37, 40, 41]),
    LottoVo(round: '1178회', numbers: [5, 6, 11, 27, 43, 44]),
    LottoVo(round: '1171회', numbers: [3, 6, 7, 11, 12, 17]),
    LottoVo(round: '1162회', numbers: [20, 21, 22, 25, 28, 29]),
  ];
  final oddEventNumbers = lottoNumbers.map((number) {
    return OddEvenStatisticsVo(
      round: number.round,
      oddNumbers: number.numbers.where((number) => number % 2 == 1).toList(),
      evenNumbers: number.numbers.where((number) => number % 2 == 0).toList(),
    );
  }).toList();

  int totalOdd = 0;
  int totalEven = 0;

  for (final stat in oddEventNumbers) {
    totalOdd += stat.oddNumbers.length;
    totalEven += stat.evenNumbers.length;
  }

  return Column(
    children: [
      _statisticsHeader(
        rightWidget: Row(
          children: [
            const Text('홀짝 평균 ', style: bodyS),
            Text(
              '${totalOdd / lottoNumbers.length} : ${totalEven / lottoNumbers.length}',
              style: subtitle2,
            ),
          ],
        ),
      ),
      const HorizontalDivider(),
      Expanded(child: _oddEvenNumbers(oddEventNumbers: oddEventNumbers)),
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
                    children: [
                      Row(
                        children: item.oddNumbers.mapIndexed((index, number) {
                          return Row(
                            children: [
                              const SizedBox(width: 8),
                              _number(number: number),
                            ],
                          );
                        }).toList(),
                      ),
                      const SizedBox(width: 8),
                      const Text(' : ', style: bodyL),
                      Row(
                        children: item.evenNumbers.mapIndexed((index, number) {
                          return Row(
                            children: [
                              const SizedBox(width: 8),
                              _number(number: number),
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
