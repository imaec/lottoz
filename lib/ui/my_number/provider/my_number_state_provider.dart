import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locator/get_it.dart';
import 'package:lottoz/provider/lotto_notifier.dart';
import 'package:lottoz/ui/my_number/provider/my_number_notifier.dart';

final myNumberNotifierProvider = StateNotifierProvider<MyNumberNotifier, MyNumberState>((ref) {
  return MyNumberNotifier(repository: locator<LottoRepository>());
});
