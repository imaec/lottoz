import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locator/get_it.dart';
import 'package:lottoz/ui/recommend/provider/recommend_notifier.dart';

final recommendNotifierProvider = StateNotifierProvider<RecommendNotifier, RecommendState>((ref) {
  return RecommendNotifier(repository: locator())..fetchLottoNumbers();
});
