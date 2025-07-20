class StatisticsRangeVo {
  final int start;
  final int end;

  StatisticsRangeVo({required this.start, required this.end});

  static List<StatisticsRangeVo> get sumRanges => [
    StatisticsRangeVo(start: 21, end: 40),
    StatisticsRangeVo(start: 41, end: 60),
    StatisticsRangeVo(start: 61, end: 80),
    StatisticsRangeVo(start: 81, end: 100),
    StatisticsRangeVo(start: 101, end: 120),
    StatisticsRangeVo(start: 121, end: 140),
    StatisticsRangeVo(start: 141, end: 160),
    StatisticsRangeVo(start: 161, end: 180),
    StatisticsRangeVo(start: 181, end: 200),
    StatisticsRangeVo(start: 201, end: 220),
    StatisticsRangeVo(start: 221, end: 240),
    StatisticsRangeVo(start: 241, end: 260),
  ];

  static List<StatisticsRangeVo> get pickRanges => [
    StatisticsRangeVo(start: 1, end: 10),
    StatisticsRangeVo(start: 11, end: 20),
    StatisticsRangeVo(start: 21, end: 30),
    StatisticsRangeVo(start: 31, end: 40),
    StatisticsRangeVo(start: 41, end: 45),
  ];

  String get range => '$start-$end';

  bool isContains(int sum) => sum >= start && sum <= end;
}
