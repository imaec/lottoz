// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_lotto_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyLottoDto _$MyLottoDtoFromJson(Map<String, dynamic> json) => MyLottoDto(
  id: (json['id'] as num?)?.toInt(),
  no1: (json['no1'] as num).toInt(),
  no2: (json['no2'] as num).toInt(),
  no3: (json['no3'] as num).toInt(),
  no4: (json['no4'] as num).toInt(),
  no5: (json['no5'] as num).toInt(),
  no6: (json['no6'] as num).toInt(),
);

Map<String, dynamic> _$MyLottoDtoToJson(MyLottoDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'no1': instance.no1,
      'no2': instance.no2,
      'no3': instance.no3,
      'no4': instance.no4,
      'no5': instance.no5,
      'no6': instance.no6,
    };
