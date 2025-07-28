import 'package:domain/domain.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottoz/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationSettingState {
  final NotificationSettingEvent? event;
  final bool isCheckOn;
  final bool isPurchaseOn;
  final String purchaseTimeDayOfWeek;
  final String purchaseTimeAmPm;
  final int purchaseTimeHour;
  final int purchaseTimeMinute;

  NotificationSettingState({
    required this.event,
    required this.isCheckOn,
    required this.isPurchaseOn,
    required this.purchaseTimeDayOfWeek,
    required this.purchaseTimeAmPm,
    required this.purchaseTimeHour,
    required this.purchaseTimeMinute,
  });

  factory NotificationSettingState.init() => NotificationSettingState(
    event: null,
    isCheckOn: false,
    isPurchaseOn: false,
    purchaseTimeDayOfWeek: '금',
    purchaseTimeAmPm: '오후',
    purchaseTimeHour: 6,
    purchaseTimeMinute: 0,
  );

  NotificationSettingState copyWith({
    NotificationSettingEvent? event,
    bool? isCheckOn,
    bool? isPurchaseOn,
    String? purchaseTimeDayOfWeek,
    String? purchaseTimeAmPm,
    int? purchaseTimeHour,
    int? purchaseTimeMinute,
  }) => NotificationSettingState(
    event: event ?? this.event,
    isCheckOn: isCheckOn ?? this.isCheckOn,
    isPurchaseOn: isPurchaseOn ?? this.isPurchaseOn,
    purchaseTimeDayOfWeek: purchaseTimeDayOfWeek ?? this.purchaseTimeDayOfWeek,
    purchaseTimeAmPm: purchaseTimeAmPm ?? this.purchaseTimeAmPm,
    purchaseTimeHour: purchaseTimeHour ?? this.purchaseTimeHour,
    purchaseTimeMinute: purchaseTimeMinute ?? this.purchaseTimeMinute,
  );
}

sealed class NotificationSettingEvent {}

class ShowAppSettingInfoDialog extends NotificationSettingEvent {}

class NotificationSettingNotifier extends StateNotifier<NotificationSettingState> {
  final SettingRepository repository;

  NotificationSettingNotifier({required this.repository}) : super(NotificationSettingState.init());

  Future<PermissionStatus> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    if (status.isPermanentlyDenied) {
      state = state.copyWith(event: ShowAppSettingInfoDialog());
    }
    return status;
  }

  fetchNotificationSetting() async {
    final futures = await Future.wait([
      repository.isCheckLottoNotificationOn(),
      repository.isPurchaseNotificationOn(),
      repository.getPurchaseNotificationTime(),
    ]);

    final isCheckOn = futures[0] as bool;
    final isPurchaseOn = futures[1] as bool;
    final purchaseNotificationTime = futures[2] as PurchaseNotificationTimeDto;

    state = state.copyWith(
      isCheckOn: isCheckOn,
      isPurchaseOn: isPurchaseOn,
      purchaseTimeDayOfWeek: purchaseNotificationTime.dayOfWeek,
      purchaseTimeAmPm: purchaseNotificationTime.amPm,
      purchaseTimeHour: purchaseNotificationTime.hour,
      purchaseTimeMinute: purchaseNotificationTime.minute,
    );
  }

  toggleCheckNotification({required bool isOn}) async {
    if (isOn) {
      final status = await requestNotificationPermission();
      if (status.isGranted) {
        await repository.updateCheckLottoNotification(isOn: isOn);
        state = state.copyWith(isCheckOn: isOn);

        await _scheduleWeeklyNotification(
          id: 0,
          title: '로또 당첨 확인 알림',
          body: '로또 번호가 추첨 되었어요. 내 번호가 당첨 되었는지 확인 해보세요!',
          channelId: 'weekly_check_channel_id',
          channelName: '매주 로또 확인 알림',
          dayOfWeek: '토',
          amPm: '오후',
          hour: 9,
          minute: 0,
        );
      }
    } else {
      await repository.updateCheckLottoNotification(isOn: isOn);
      state = state.copyWith(isCheckOn: isOn);
    }
  }

  togglePurchaseNotification({required bool isOn}) async {
    if (isOn) {
      final status = await requestNotificationPermission();
      if (status.isGranted) {
        await repository.updatePurchaseNotification(isOn: isOn);
        state = state.copyWith(isPurchaseOn: isOn);

        await _scheduleWeeklyNotification(
          id: 1,
          title: '로또 구매 알림',
          body: '로또 구매 할 시간입니다. 이번주도 로또를 구매 해보세요!',
          channelId: 'weekly_purchase_channel_id',
          channelName: '매주 로또 구매 알림',
          dayOfWeek: state.purchaseTimeDayOfWeek,
          amPm: state.purchaseTimeAmPm,
          hour: state.purchaseTimeHour,
          minute: state.purchaseTimeMinute,
        );
      }
    } else {
      await repository.updatePurchaseNotification(isOn: isOn);
      state = state.copyWith(isPurchaseOn: isOn);
    }
  }

  updatePurchaseNotificationTime({
    required String dayOfWeek,
    required String amPm,
    required int hour,
    required int minute,
  }) async {
    await _scheduleWeeklyNotification(
      id: 1,
      title: '로또 구매 알림',
      body: '로또 구매 할 시간입니다. 이번주도 로또를 구매 해보세요!',
      channelId: 'weekly_purchase_channel_id',
      channelName: '매주 로또 구매 알림',
      dayOfWeek: dayOfWeek,
      amPm: amPm,
      hour: hour,
      minute: minute,
    );
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

  Future<void> _scheduleWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required String channelId,
    required String channelName,
    required String dayOfWeek,
    required String amPm,
    required int hour,
    required int minute,
  }) async {
    final scheduledDate = _nextInstanceOfWeekdayTime(
      dayOfWeek: dayOfWeek,
      amPm: amPm,
      hour: hour,
      minute: minute,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'payload',
    );
  }

  /// 요일, 시간에 맞는 다음 알림 시각 구하기
  tz.TZDateTime _nextInstanceOfWeekdayTime({
    required String dayOfWeek,
    required String amPm,
    required int hour,
    required int minute,
  }) {
    final weekday = _dayOfWeekToInt(dayOfWeek: dayOfWeek);
    final hour24 = _amPmHourTo24(amPm: amPm, hour: hour);
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour24,
      minute,
    );
    // 해당 요일/시간까지 앞으로 이동
    while (scheduledDate.weekday != weekday || scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  /// 한글 요일 → DateTime.weekday 변환 (월:1 ~ 일:7)
  int _dayOfWeekToInt({required String dayOfWeek}) {
    switch (dayOfWeek) {
      case '월':
        return DateTime.monday;
      case '화':
        return DateTime.tuesday;
      case '수':
        return DateTime.wednesday;
      case '목':
        return DateTime.thursday;
      case '금':
        return DateTime.friday;
      case '토':
        return DateTime.saturday;
      case '일':
        return DateTime.sunday;
      default:
        throw ArgumentError('잘못된 요일: $dayOfWeek');
    }
  }

  /// 오전/오후 + hour → 24시간제로 변환
  int _amPmHourTo24({required String amPm, required int hour}) {
    if (amPm == '오전') {
      return hour == 12 ? 0 : hour;
    } else if (amPm == '오후') {
      return hour == 12 ? 12 : hour + 12;
    } else {
      throw ArgumentError('잘못된 오전/오후: $amPm');
    }
  }

  clearEvent() {
    state = state.copyWith(event: null);
  }
}
