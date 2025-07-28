// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_notification_time_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseNotificationTimeDto _$PurchaseNotificationTimeDtoFromJson(
  Map<String, dynamic> json,
) => PurchaseNotificationTimeDto(
  dayOfWeek: json['dayOfWeek'] as String,
  amPm: json['amPm'] as String,
  hour: (json['hour'] as num).toInt(),
  minute: (json['minute'] as num).toInt(),
);

Map<String, dynamic> _$PurchaseNotificationTimeDtoToJson(
  PurchaseNotificationTimeDto instance,
) => <String, dynamic>{
  'dayOfWeek': instance.dayOfWeek,
  'amPm': instance.amPm,
  'hour': instance.hour,
  'minute': instance.minute,
};
