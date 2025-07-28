import 'package:json_annotation/json_annotation.dart';

part 'purchase_notification_time_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class PurchaseNotificationTimeDto {
  final String dayOfWeek;
  final String amPm;
  final int hour;
  final int minute;

  PurchaseNotificationTimeDto({
    required this.dayOfWeek,
    required this.amPm,
    required this.hour,
    required this.minute,
  });

  factory PurchaseNotificationTimeDto.fromJson(Map<String, dynamic> json) => _$PurchaseNotificationTimeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseNotificationTimeDtoToJson(this);
}
