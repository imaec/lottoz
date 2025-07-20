import 'package:go_router/go_router.dart';
import 'package:lottoz/ui/home/home_screen.dart';
import 'package:lottoz/ui/main/main_screen.dart';
import 'package:lottoz/ui/more/more_screen.dart';
import 'package:lottoz/ui/my_number/my_number_screen.dart';
import 'package:lottoz/ui/recommend/recommend_screen.dart';
import 'package:lottoz/ui/statistics/statistics_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    _mainRoute,
    GoRoute(
      path: '/my_number',
      builder: (context, state) => const MyNumberScreen(),
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
