import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locator/get_it.dart';
import 'package:lottoz/ui/latest_round_list/provider/latest_round_list_notifier.dart';

final latestRoundListNotifierProvider =
    StateNotifierProvider<LatestRoundListNotifier, LatestRoundListState>((ref) {
      return LatestRoundListNotifier(repository: locator())..fetchLottoNumbers();
    });
