import 'package:json_annotation/json_annotation.dart';

part 'my_lotto_dto.g.dart';

@JsonSerializable(explicitToJson: true)
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

  factory MyLottoDto.fromJson(Map<String, dynamic> json) => _$MyLottoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MyLottoDtoToJson(this);

  factory MyLottoDto.init() =>
      MyLottoDto(id: 0,
          no1: 0,
          no2: 0,
          no3: 0,
          no4: 0,
          no5: 0,
          no6: 0);

  List<int> get numbers => [no1, no2, no3, no4, no5, no6];
}

extension MyLottoDtoListExtension on List<MyLottoDto> {
  List<MyLottoDto> removeDuplicates(List<MyLottoDto> otherList) {
    final result = <MyLottoDto>[];

    // this에서 otherList에 없는 항목 추가
    for (final item in this) {
      if (!_contains(otherList, item)) {
        result.add(item);
      }
    }

    // otherList에서 this에 없는 항목 추가
    for (final item in otherList) {
      if (!_contains(this, item)) {
        result.add(item);
      }
    }

    return result;
  }

  bool _equals(MyLottoDto a, MyLottoDto b) {
    return a.no1 == b.no1 &&
        a.no2 == b.no2 &&
        a.no3 == b.no3 &&
        a.no4 == b.no4 &&
        a.no5 == b.no5 &&
        a.no6 == b.no6;
  }

  bool _contains(List<MyLottoDto> list, MyLottoDto target) {
    for (final item in list) {
      if (_equals(item, target)) return true;
    }
    return false;
  }
}
