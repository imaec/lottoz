// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lotto_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LottoResponse _$LottoResponseFromJson(Map<String, dynamic> json) =>
    LottoResponse(
      bnusNo: (json['bnusNo'] as num).toInt(),
      drwNo: (json['drwNo'] as num).toInt(),
      drwNoDate: json['drwNoDate'] as String,
      drwtNo1: (json['drwtNo1'] as num).toInt(),
      drwtNo2: (json['drwtNo2'] as num).toInt(),
      drwtNo3: (json['drwtNo3'] as num).toInt(),
      drwtNo4: (json['drwtNo4'] as num).toInt(),
      drwtNo5: (json['drwtNo5'] as num).toInt(),
      drwtNo6: (json['drwtNo6'] as num).toInt(),
      firstAccumamnt: (json['firstAccumamnt'] as num).toDouble(),
      firstPrzwnerCo: (json['firstPrzwnerCo'] as num).toInt(),
      firstWinamnt: (json['firstWinamnt'] as num).toDouble(),
      returnValue: json['returnValue'] as String,
      totSellamnt: (json['totSellamnt'] as num).toDouble(),
    );

Map<String, dynamic> _$LottoResponseToJson(LottoResponse instance) =>
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
      'returnValue': instance.returnValue,
      'totSellamnt': instance.totSellamnt,
    };
