import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:go_router/go_router.dart';
import 'package:lottoz/ui/home/home_screen.dart';
import 'package:lottoz/ui/latest_round_list/latest_round_list_screen.dart';
import 'package:lottoz/ui/lotto_detail/lotto_detail_screen.dart';
import 'package:lottoz/ui/main/main_screen.dart';
import 'package:lottoz/ui/more/more_screen.dart';
import 'package:lottoz/ui/my_number/my_number_screen.dart';
import 'package:lottoz/ui/qr/qr_scanner_screen.dart';
import 'package:lottoz/ui/recommend/recommend_screen.dart';
import 'package:lottoz/ui/statistics/statistics_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    _mainRoute,
    GoRoute(
      path: '/latestRoundList',
      builder: (context, state) => const LatestRoundListScreen(),
    ),
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        final lotto = state.extra as LottoDto;
        return LottoDetailScreen(lotto: lotto);
      },
    ),
    GoRoute(
      path: '/myNumber',
      builder: (context, state) => const MyNumberScreen(),
    ),
    GoRoute(
      path: '/qrScanner',
      builder: (context, state) => const QrScannerScreen(),
    ),
  ],
);

final _mainRoute = ShellRoute(
  builder: (context, state, child) => MainScreen(child: child),
  routes: [
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
    ),
    GoRoute(
      path: '/statistics',
      pageBuilder: (context, state) => const NoTransitionPage(child: StatisticsScreen()),
    ),
    GoRoute(
      path: '/recommend',
      pageBuilder: (context, state) => const NoTransitionPage(child: RecommendScreen()),
    ),
    GoRoute(
      path: '/more',
      pageBuilder: (context, state) => const NoTransitionPage(child: MoreScreen()),
    ),
  ],
);
