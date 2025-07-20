import 'package:data/mapper/data_to_domain_mapper.dart';
import 'package:domain/domain.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_lotto_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class MyLottoEntity extends DataToDomainMapper<MyLottoDto> {
  final int? id;
  final int no1;
  final int no2;
  final int no3;
  final int no4;
  final int no5;
  final int no6;

  MyLottoEntity({
    this.id,
    required this.no1,
    required this.no2,
    required this.no3,
    required this.no4,
    required this.no5,
    required this.no6,
  });

  factory MyLottoEntity.fromJson(Map<String, dynamic> json) => _$MyLottoEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MyLottoEntityToJson(this);

  @override
  MyLottoDto mapper() => MyLottoDto(
    id: id ?? 0,
    no1: no1,
    no2: no2,
    no3: no3,
    no4: no4,
    no5: no5,
    no6: no6,
  );
}
