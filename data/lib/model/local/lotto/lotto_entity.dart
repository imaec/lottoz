import 'package:data/mapper/data_to_domain_mapper.dart';
import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lotto_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class LottoEntity extends DataToDomainMapper<LottoDto> {
  final int bnusNo;
  final int drwNo;
  final String drwNoDate;
  final int drwtNo1;
  final int drwtNo2;
  final int drwtNo3;
  final int drwtNo4;
  final int drwtNo5;
  final int drwtNo6;
  final int firstAccumamnt;
  final int firstPrzwnerCo;
  final int firstWinamnt;
  final int totSellamnt;

  LottoEntity({
    required this.bnusNo,
    required this.drwNo,
    required this.drwNoDate,
    required this.drwtNo1,
    required this.drwtNo2,
    required this.drwtNo3,
    required this.drwtNo4,
    required this.drwtNo5,
    required this.drwtNo6,
    required this.firstAccumamnt,
    required this.firstPrzwnerCo,
    required this.firstWinamnt,
    required this.totSellamnt,
  });

  factory LottoEntity.fromJson(Map<String, dynamic> json) => _$LottoEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LottoEntityToJson(this);

  @override
  LottoDto mapper() => LottoDto(
    bnusNo: bnusNo,
    drwNo: drwNo,
    drwNoDate: drwNoDate,
    drwtNo1: drwtNo1,
    drwtNo2: drwtNo2,
    drwtNo3: drwtNo3,
    drwtNo4: drwtNo4,
    drwtNo5: drwtNo5,
    drwtNo6: drwtNo6,
    firstAccumamnt: firstAccumamnt,
    firstPrzwnerCo: firstPrzwnerCo,
    firstWinamnt: firstWinamnt,
    returnValue: '',
    totSellamnt: totSellamnt,
  );
}
