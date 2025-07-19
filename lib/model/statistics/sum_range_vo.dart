class SumRangeVo {
  final int start;
  final int end;

  SumRangeVo({required this.start, required this.end});

  bool isContains(int sum) => sum >= start && sum <= end;
}
