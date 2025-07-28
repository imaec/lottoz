import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationSettingState {
  final bool isCheckOn;
  final bool isPurchaseOn;
  final String purchaseTimeDayOfWeek;
  final String purchaseTimeAmPm;
  final int purchaseTimeHour;
  final int purchaseTimeMinute;

  NotificationSettingState({
    required this.isCheckOn,
    required this.isPurchaseOn,
    required this.purchaseTimeDayOfWeek,
    required this.purchaseTimeAmPm,
    required this.purchaseTimeHour,
    required this.purchaseTimeMinute,
  });

  factory NotificationSettingState.init() => NotificationSettingState(
    isCheckOn: false,
    isPurchaseOn: false,
    purchaseTimeDayOfWeek: '금',
    purchaseTimeAmPm: '오후',
    purchaseTimeHour: 6,
    purchaseTimeMinute: 0,
  );

  NotificationSettingState copyWith({
    bool? isCheckOn,
    bool? isPurchaseOn,
    String? purchaseTimeDayOfWeek,
    String? purchaseTimeAmPm,
    int? purchaseTimeHour,
    int? purchaseTimeMinute,
  }) => NotificationSettingState(
    isCheckOn: isCheckOn ?? this.isCheckOn,
    isPurchaseOn: isPurchaseOn ?? this.isPurchaseOn,
    purchaseTimeDayOfWeek: purchaseTimeDayOfWeek ?? this.purchaseTimeDayOfWeek,
    purchaseTimeAmPm: purchaseTimeAmPm ?? this.purchaseTimeAmPm,
    purchaseTimeHour: purchaseTimeHour ?? this.purchaseTimeHour,
    purchaseTimeMinute: purchaseTimeMinute ?? this.purchaseTimeMinute,
  );
}

class NotificationSettingNotifier extends StateNotifier<NotificationSettingState> {
  final SettingRepository repository;

  NotificationSettingNotifier({required this.repository}) : super(NotificationSettingState.init());

  fetchNotificationSetting() async {
    final futures = await Future.wait([
      repository.isCheckLottoNotificationOn(),
      repository.isPurchaseNotificationOn(),
      repository.getPurchaseNotificationTime(),
    ]);

    final purchaseNotificationTime = futures[2] as PurchaseNotificationTimeDto;
    state = state.copyWith(
      isCheckOn: futures[0] as bool,
      isPurchaseOn: futures[1] as bool,
      purchaseTimeDayOfWeek: purchaseNotificationTime.dayOfWeek,
      purchaseTimeAmPm: purchaseNotificationTime.amPm,
      purchaseTimeHour: purchaseNotificationTime.hour,
      purchaseTimeMinute: purchaseNotificationTime.minute,
    );
  }

  toggleCheckNotification({required bool isOn}) async {
    await repository.updateCheckLottoNotification(isOn: isOn);
    state = state.copyWith(isCheckOn: isOn);
  }

  togglePurchaseNotification({required bool isOn}) async {
    await repository.updatePurchaseNotification(isOn: isOn);
    state = state.copyWith(isPurchaseOn: isOn);
  }

  updatePurchaseNotificationTime({
    required String dayOfWeek,
    required String amPm,
    required int hour,
    required int minute,
  }) async {
    await repository.updatePurchaseNotificationTime(
      purchaseNotificationTime: PurchaseNotificationTimeDto(
        dayOfWeek: dayOfWeek,
        amPm: amPm,
        hour: hour,
        minute: minute,
      ),
    );
    state = state.copyWith(
      purchaseTimeDayOfWeek: dayOfWeek,
      purchaseTimeAmPm: amPm,
      purchaseTimeHour: hour,
      purchaseTimeMinute: minute,
    );
  }
}
