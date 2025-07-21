import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locator/get_it.dart';
import 'package:lottoz/provider/lotto_notifier.dart';

final lottoNotifierProvider = StateNotifierProvider<LottoNotifier, LottoState>((ref) {
  return LottoNotifier(repository: locator())..fetchLottoNumber();
});
