class StatisticsRangeVo {
  final int start;
  final int end;

  StatisticsRangeVo({required this.start, required this.end});

  bool isContains(int sum) => sum >= start && sum <= end;

  String get range => '$start-$end';
}
