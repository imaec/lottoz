import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:designsystem/component/ads/app_open_ad.dart';
import 'package:designsystem/component/ads/ad.dart';
import 'package:designsystem/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
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

const bool isAdEnable = true;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
void backgroundNotificationTapHandler(NotificationResponse response) {
  // todo : backgroundNotificationTapHandler
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 초기화
  await Future.wait([
    // Firebase 초기화
    Firebase.initializeApp(),
    // Supabase 초기화
    Supabase.initialize(
      url: 'https://cmmlmrmpmjhedsnpsjyg.supabase.co',
      anonKey: 'sb_publishable_guT4BXWCOdjRMybmFzcRZA_7d3ql3-j',
    ),
    // Local Notification 초기화
    initNotifications(),
    // iOS 알림 권한 요청
    _requestIOSPermissions(),
    _requestATT(),
    // Ad Mob 초기화
    MobileAds.instance.initialize(),
  ]);

  if (isAdEnable) initAd();

  // get_it 초기화
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

Future<void> _requestIOSPermissions() async {
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: false, sound: false);
}

Future<void> _requestATT() async {
  final status = await AppTrackingTransparency.trackingAuthorizationStatus;
  if (status == TrackingStatus.notDetermined) {
    await AppTrackingTransparency.requestTrackingAuthorization();
  }
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
