import 'package:go_router/go_router.dart';
import 'package:lottoz/ui/main/main_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen()
    ),
  ],
);
