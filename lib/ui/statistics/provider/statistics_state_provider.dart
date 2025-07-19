import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locator/get_it.dart';
import 'package:lottoz/ui/statistics/provider/statistics_notifier.dart';

final statisticsNotifierProvider = StateNotifierProvider<StatisticsNotifier, StatisticsState>((ref) {
  return StatisticsNotifier(repository: locator<LottoRepository>())..fetchLottoNumber();
});
