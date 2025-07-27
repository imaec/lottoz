import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locator/get_it.dart';
import 'package:lottoz/router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://cmmlmrmpmjhedsnpsjyg.supabase.co',
    anonKey: 'sb_publishable_guT4BXWCOdjRMybmFzcRZA_7d3ql3-j',
  );
  initLocator();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(const ProviderScope(child: LottoZApp()));
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
