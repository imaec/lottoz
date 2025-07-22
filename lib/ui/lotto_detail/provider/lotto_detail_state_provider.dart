import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locator/get_it.dart';
import 'package:lottoz/ui/lotto_detail/provider/lotto_detail_notifier.dart';

final lottoDetailNotifierProvider = StateNotifierProvider<LottoDetailNotifier, LottoDetailState>((
  ref,
) {
  return LottoDetailNotifier(repository: locator());
});
