part of '../statistics_screen.dart';

Widget _continuousTabContent() {
  return Column(
    children: [
      _statisticsHeader(),
      const HorizontalDivider(),
      Expanded(child: _continuousNumbers()),
    ],
  );
}

Widget _continuousNumbers() {
  final lottoNumbers = [
    LottoVo(round: '1180회', numbers: [6, 12, 18, 37, 40, 41]),
    LottoVo(round: '1178회', numbers: [5, 6, 11, 27, 43, 44]),
    LottoVo(round: '1171회', numbers: [3, 6, 7, 11, 12, 17]),
    LottoVo(round: '1162회', numbers: [20, 21, 22, 25, 28, 29]),
  ];
  final continuousStatistics = lottoNumbers.map((vo) {
    final continuousNumbers = getContinuousNumbers(numbers: vo.numbers);
    final description = getContinuousDescription(continuousNumbers: continuousNumbers);
    return ContinuousStatisticsVo(
      round: vo.round,
      numbers: vo.numbers,
      continuousNumbers: continuousNumbers,
      description: description,
    );
  }).toList();

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
                    children: item.numbers.mapIndexed((index, number) {
                      final isContinuous = continuousSet.contains(number);

                      return Row(
                        children: [
                          SizedBox(width: index < item.numbers.length ? 8 : 0),
                          _number(
                            number: number,
                            numberColor: isContinuous ? null : gray700,
                            backgroundColor:
                                isContinuous ? getLottoColor(number: number) : Colors.transparent,
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

List<List<int>> getContinuousNumbers({required List<int> numbers}) {
  if (numbers.isEmpty) return [];

  // 먼저 오름차순 정렬
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

String getContinuousDescription({required List<List<int>> continuousNumbers}) {
  if (continuousNumbers.isEmpty) return '연속번호 없음';

  final Map<int, int> groupCount = {};
  for (final group in continuousNumbers) {
    groupCount[group.length] = (groupCount[group.length] ?? 0) + 1;
  }
  return groupCount.entries.map((e) => '${e.key}연속 ${e.value}개').join('\n');
}
