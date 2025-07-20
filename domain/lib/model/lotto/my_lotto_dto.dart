class MyLottoDto {
  final int? id;
  final int no1;
  final int no2;
  final int no3;
  final int no4;
  final int no5;
  final int no6;

  MyLottoDto({
    this.id,
    required this.no1,
    required this.no2,
    required this.no3,
    required this.no4,
    required this.no5,
    required this.no6,
  });

  factory MyLottoDto.init() => MyLottoDto(id: 0, no1: 0, no2: 0, no3: 0, no4: 0, no5: 0, no6: 0);

  List<int> get numbers => [no1, no2, no3, no4, no5, no6];
}
