part of '../statistics_screen.dart';

Widget _pickTabContent() {
  return Column(
    children: [
      _statisticsHeader(),
      const HorizontalDivider(),
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _pickCounts(),
              const HorizontalDivider(),
              _unPickNumbers(),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _pickCounts() {
  final pickStatistics = [
    PickStatisticsVo(range: '1-10', count: 28),
    PickStatisticsVo(range: '11-20', count: 28),
    PickStatisticsVo(range: '21-30', count: 27),
    PickStatisticsVo(range: '31-40', count: 23),
    PickStatisticsVo(range: '41-45', count: 14),
  ];
  final maxCount = pickStatistics.map((pick) => pick.count).reduce((a, b) => a > b ? a : b);

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

Widget _unPickNumbers() {
  final unPickNumbers = [
    1,
    2,
    4,
    8,
    10,
    13,
    17,
    20,
    22,
    23,
    25,
    26,
    28,
    29,
    31,
    32,
    33,
    34,
    36,
    38,
    39,
    42,
    45
  ];
  final ranges = {
    '1-10': <int>[],
    '11-20': <int>[],
    '21-30': <int>[],
    '31-40': <int>[],
    '41-45': <int>[],
  };
  for (final num in unPickNumbers) {
    if (num <= 10) {
      ranges['1-10']!.add(num);
    } else if (num <= 20) {
      ranges['11-20']!.add(num);
    } else if (num <= 30) {
      ranges['21-30']!.add(num);
    } else if (num <= 40) {
      ranges['31-40']!.add(num);
    } else {
      ranges['41-45']!.add(num);
    }
  }

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
          children: ranges.entries.map((range) {
            return Row(
              children: [
                SizedBox(
                  width: 65,
                  child: Text(range.key, style: bodyS, textAlign: TextAlign.center),
                ),
                Container(height: 40, width: 1, color: gray100),
                Expanded(
                  child: Row(
                    children: range.value.mapIndexed((index, number) {
                      return Row(
                        children: [
                          SizedBox(width: index < range.value.length ? 8 : 0),
                          _number(number: number),
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
