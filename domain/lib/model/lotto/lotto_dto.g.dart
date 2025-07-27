// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lotto_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LottoDto _$LottoDtoFromJson(Map<String, dynamic> json) => LottoDto(
  bnusNo: (json['bnus_no'] as num).toInt(),
  drwNo: (json['drw_no'] as num).toInt(),
  drwNoDate: json['drw_no_date'] as String,
  drwtNo1: (json['drwt_no1'] as num).toInt(),
  drwtNo2: (json['drwt_no2'] as num).toInt(),
  drwtNo3: (json['drwt_no3'] as num).toInt(),
  drwtNo4: (json['drwt_no4'] as num).toInt(),
  drwtNo5: (json['drwt_no5'] as num).toInt(),
  drwtNo6: (json['drwt_no6'] as num).toInt(),
  firstAccumamnt: (json['first_accumamnt'] as num).toInt(),
  firstPrzwnerCo: (json['first_przwner_co'] as num).toInt(),
  firstWinamnt: (json['first_winamnt'] as num).toInt(),
  returnValue: json['return_value'] as String,
  totSellamnt: (json['tot_sellamnt'] as num).toInt(),
);

Map<String, dynamic> _$LottoDtoToJson(LottoDto instance) => <String, dynamic>{
  'drw_no': instance.drwNo,
  'drw_no_date': instance.drwNoDate,
  'drwt_no1': instance.drwtNo1,
  'drwt_no2': instance.drwtNo2,
  'drwt_no3': instance.drwtNo3,
  'drwt_no4': instance.drwtNo4,
  'drwt_no5': instance.drwtNo5,
  'drwt_no6': instance.drwtNo6,
  'bnus_no': instance.bnusNo,
  'first_accumamnt': instance.firstAccumamnt,
  'first_przwner_co': instance.firstPrzwnerCo,
  'first_winamnt': instance.firstWinamnt,
  'return_value': instance.returnValue,
  'tot_sellamnt': instance.totSellamnt,
};
