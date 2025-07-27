import 'package:json_annotation/json_annotation.dart';

part 'lotto_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class LottoDto {
  @JsonKey(name: 'drw_no') final int drwNo;
  @JsonKey(name: 'drw_no_date') final String drwNoDate;
  @JsonKey(name: 'drwt_no1') final int drwtNo1;
  @JsonKey(name: 'drwt_no2') final int drwtNo2;
  @JsonKey(name: 'drwt_no3') final int drwtNo3;
  @JsonKey(name: 'drwt_no4') final int drwtNo4;
  @JsonKey(name: 'drwt_no5') final int drwtNo5;
  @JsonKey(name: 'drwt_no6') final int drwtNo6;
  @JsonKey(name: 'bnus_no') final int bnusNo;
  @JsonKey(name: 'first_accumamnt') final int firstAccumamnt;
  @JsonKey(name: 'first_przwner_co') final int firstPrzwnerCo;
  @JsonKey(name: 'first_winamnt') final int firstWinamnt;
  @JsonKey(name: 'return_value') final String returnValue;
  @JsonKey(name: 'tot_sellamnt') final int totSellamnt;

  LottoDto({
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
    required this.returnValue,
    required this.totSellamnt,
  });

  factory LottoDto.init() => LottoDto(
    bnusNo: 0,
    drwNo: 0,
    drwNoDate: '',
    drwtNo1: 0,
    drwtNo2: 0,
    drwtNo3: 0,
    drwtNo4: 0,
    drwtNo5: 0,
    drwtNo6: 0,
    firstAccumamnt: 0,
    firstPrzwnerCo: 0,
    firstWinamnt: 0,
    returnValue: '',
    totSellamnt: 0,
  );

  factory LottoDto.fromJson(Map<String, dynamic> json) => _$LottoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LottoDtoToJson(this);

  int get sum => drwtNo1 + drwtNo2 + drwtNo3 + drwtNo4 + drwtNo5 + drwtNo6;

  List<int> get numbers => [drwtNo1, drwtNo2, drwtNo3, drwtNo4, drwtNo5, drwtNo6];
}
