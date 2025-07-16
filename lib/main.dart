import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottoz/router/go_router.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

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
