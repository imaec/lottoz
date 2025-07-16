import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:lottoz/router/go_router.dart';

void main() {
  runApp(const LottoZApp());
}

class LottoZApp extends StatelessWidget {
  const LottoZApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      theme: appTheme,
    );
  }
}
