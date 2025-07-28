import 'package:designsystem/component/ads/app_open_ad.dart';
import 'package:designsystem/component/ads/banner_ad.dart';
import 'package:designsystem/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:locator/get_it.dart';
import 'package:lottoz/router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void backgroundNotificationTapHandler(NotificationResponse response) {
  // todo : backgroundNotificationTapHandler
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Supabase.initialize(
    url: 'https://cmmlmrmpmjhedsnpsjyg.supabase.co',
    anonKey: 'sb_publishable_guT4BXWCOdjRMybmFzcRZA_7d3ql3-j',
  );
  await initNotifications();
  await requestIOSPermissions();
  initAd();
  initLocator();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(const ProviderScope(child: LottoZApp()));
}

Future<void> initNotifications() async {
  initializeTimeZones();
  setLocalLocation(getLocation('Asia/Seoul'));

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (response) {
      // todo : onDidReceiveNotificationResponse
    },
    onDidReceiveBackgroundNotificationResponse: backgroundNotificationTapHandler,
  );
}

Future<void> requestIOSPermissions() async {
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: false, sound: false);
}

class LottoZApp extends StatefulWidget {
  const LottoZApp({super.key});

  @override
  State<LottoZApp> createState() => _LottoZAppState();
}

class _LottoZAppState extends State<LottoZApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      showAppOpenAdIfAvailable();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: appRouter, theme: appTheme);
  }
}
