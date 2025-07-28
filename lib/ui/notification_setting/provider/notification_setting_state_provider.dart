import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locator/get_it.dart';
import 'package:lottoz/ui/notification_setting/provider/notification_setting_notifier.dart';

final notificationSettingNotifierProvider =
    StateNotifierProvider<NotificationSettingNotifier, NotificationSettingState>((ref) {
      return NotificationSettingNotifier(repository: locator());
    });
