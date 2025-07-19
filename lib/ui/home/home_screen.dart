import 'package:collection/collection.dart';
import 'package:core/extension/double_extension.dart';
import 'package:core/utils/lotto_utils.dart';
import 'package:designsystem/designsystem.dart';
import 'package:domain/domain.dart';
import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottoz/provider/lotto_notifier.dart';
import 'package:lottoz/provider/lotto_state_provider.dart';

part 'home_store_list.dart';

part 'lastest_round_winning_numbers.dart';

part 'latest_rounds.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lottoState = ref.watch(lottoNotifierProvider);

    return Scaffold(body: _homeBody(lottoState: lottoState));
  }

  _homeBody({required LottoState lottoState}) {
    if (lottoState.lottoNumbers.isNotEmpty) {
      return SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              _latestRoundWinningNumbers(lottoDto: lottoState.lottoNumbers.first),
              const HorizontalDivider(),
              _latestRounds(lottoNumbers: lottoState.lottoNumbers.sublist(1, 11).toList()),
              const HorizontalDivider(),
              _homeStoreList(stores: lottoState.stores),
            ],
          ),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
