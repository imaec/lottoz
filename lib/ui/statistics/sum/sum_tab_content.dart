part of '../statistics_screen.dart';

Widget _sumTabContent() {
  return Column(
    children: [
      _sumTabCondition(),
      _sumTabGraphHeader(),
      Expanded(child: _sumTabGraph()),
    ],
  );
}

Widget _sumTabCondition() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text('회차', style: bodyS),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: gray100),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                children: [
                  Text('1', style: subtitle2),
                  SizedBox(width: 2),
                  SvgIcon(asset: arrowDownIcon, size: 12),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('-', style: subtitle2),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: gray100),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                children: [
                  Text('1180', style: subtitle2),
                  SizedBox(width: 2),
                  SvgIcon(asset: arrowDownIcon, size: 12),
                ],
              ),
            ),
          ],
        ),
        const Row(
          children: [
            Text('1180회 평균 합계 : ', style: bodyS),
            Text('135', style: subtitle2),
          ],
        )
      ],
    ),
  );
}

Widget _sumTabGraphHeader() {
  return Container(
    color: gray700,
    child: Row(
      children: [
        SizedBox(
          width: 80,
          child: Text('합계', style: bodyS.copyWith(color: white), textAlign: TextAlign.center),
        ),
        Container(height: 40, width: 1, color: gray100),
        Expanded(
          child: Text('횟수', style: bodyS.copyWith(color: white), textAlign: TextAlign.center),
        ),
        Container(height: 40, width: 1, color: gray100),
        SizedBox(
          width: 60,
          child: Text('비율', style: bodyS.copyWith(color: white), textAlign: TextAlign.center),
        ),
      ],
    ),
  );
}

Widget _sumTabGraph() {
  final sumStatistics = [
    SumStatisticsVo(range: '21-40', count: 0, rate: 0),
    SumStatisticsVo(range: '41-60', count: 5, rate: 0.4),
    SumStatisticsVo(range: '61-80', count: 31, rate: 2.6),
    SumStatisticsVo(range: '81-100', count: 95, rate: 8.1),
    SumStatisticsVo(range: '101-120', count: 193, rate: 16.4),
    SumStatisticsVo(range: '121-140', count: 295, rate: 25),
    SumStatisticsVo(range: '141-160', count: 249, rate: 21.1),
    SumStatisticsVo(range: '161-180', count: 206, rate: 17.5),
    SumStatisticsVo(range: '181-200', count: 81, rate: 6.9),
    SumStatisticsVo(range: '201-220', count: 21, rate: 1.8),
    SumStatisticsVo(range: '221-240', count: 4, rate: 0.3),
    SumStatisticsVo(range: '241-260', count: 0, rate: 0),
  ];
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
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: sum.count / maxCount,
                          child: Container(
                            height: 20,
                            color: gray100,
                          ),
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
                  child: Text('${sum.rate}%', style: bodyS, textAlign: TextAlign.center),
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
