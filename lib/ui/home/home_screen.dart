import 'package:collection/collection.dart';
import 'package:core/utils/lotto_utils.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'home_store_list.dart';
part 'lastest_round_winning_numbers.dart';
part 'latest_rounds.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: _homeBody(),
    );
  }

  _homeBody() {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            _latestRoundWinningNumbers(),
            const HorizontalDivider(),
            _latestRounds(),
            const HorizontalDivider(),
            _homeStoreList()
          ],
        ),
      ),
    );
  }
}
