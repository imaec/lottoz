// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lotto_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LottoEntity _$LottoEntityFromJson(Map<String, dynamic> json) => LottoEntity(
  bnusNo: (json['bnusNo'] as num).toInt(),
  drwNo: (json['drwNo'] as num).toInt(),
  drwNoDate: json['drwNoDate'] as String,
  drwtNo1: (json['drwtNo1'] as num).toInt(),
  drwtNo2: (json['drwtNo2'] as num).toInt(),
  drwtNo3: (json['drwtNo3'] as num).toInt(),
  drwtNo4: (json['drwtNo4'] as num).toInt(),
  drwtNo5: (json['drwtNo5'] as num).toInt(),
  drwtNo6: (json['drwtNo6'] as num).toInt(),
  firstAccumamnt: (json['firstAccumamnt'] as num).toInt(),
  firstPrzwnerCo: (json['firstPrzwnerCo'] as num).toInt(),
  firstWinamnt: (json['firstWinamnt'] as num).toInt(),
  totSellamnt: (json['totSellamnt'] as num).toInt(),
);

Map<String, dynamic> _$LottoEntityToJson(LottoEntity instance) =>
    <String, dynamic>{
      'bnusNo': instance.bnusNo,
      'drwNo': instance.drwNo,
      'drwNoDate': instance.drwNoDate,
      'drwtNo1': instance.drwtNo1,
      'drwtNo2': instance.drwtNo2,
      'drwtNo3': instance.drwtNo3,
      'drwtNo4': instance.drwtNo4,
      'drwtNo5': instance.drwtNo5,
      'drwtNo6': instance.drwtNo6,
      'firstAccumamnt': instance.firstAccumamnt,
      'firstPrzwnerCo': instance.firstPrzwnerCo,
      'firstWinamnt': instance.firstWinamnt,
      'totSellamnt': instance.totSellamnt,
    };
