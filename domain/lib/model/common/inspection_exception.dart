class InspectionException implements Exception {
  final String content;
  final String time;

  InspectionException({required this.content, required this.time});

  @override
  String toString() => '$content, $time';
}
