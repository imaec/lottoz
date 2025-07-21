import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locator/get_it.dart';
import 'package:lottoz/ui/more/provider/more_notifier.dart';

final moreNotifierProvider = StateNotifierProvider<MoreNotifier, MoreState>((ref) {
  return MoreNotifier(lottoRepository: locator(), settingRepository: locator())
    ..fetchStatisticsSize();
});
