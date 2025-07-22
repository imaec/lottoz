import 'package:collection/collection.dart';
import 'package:core/extension/double_extension.dart';
import 'package:core/utils/lotto_utils.dart';
import 'package:designsystem/assets/icons.dart';
import 'package:designsystem/component/app_bar/lotto_app_bar.dart';
import 'package:designsystem/component/divider/horizontal_divider.dart';
import 'package:designsystem/component/media/svg_icon.dart';
import 'package:designsystem/theme/colors.dart';
import 'package:designsystem/theme/fonts.dart';
import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottoz/router/go_router.dart';
import 'package:lottoz/ui/latest_round_list/provider/latest_round_list_notifier.dart';
import 'package:lottoz/ui/latest_round_list/provider/latest_round_list_state_provider.dart';

class LatestRoundListScreen extends ConsumerWidget {
  const LatestRoundListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(latestRoundListNotifierProvider);

    return Scaffold(
      appBar: LottoAppBar(
        title: '최근 회차 결과',
        topPadding: MediaQuery.of(context).padding.top,
        hasBack: true,
      ),
      body: _latestRoundListBody(state: state),
    );
  }

  Widget _latestRoundListBody({required LatestRoundListState state}) {
    return ListView.separated(
      itemCount: state.lottoNumbers.length,
      itemBuilder: (context, index) {
        final lotto = state.lottoNumbers[index];

        return _latestRoundItem(lotto: lotto);
      },
      separatorBuilder: (context, index) {
        return const HorizontalDivider();
      },
    );
  }

  Widget _latestRoundItem({required LottoDto lotto}) {
    return GestureDetector(
      onTap: () {
        appRouter.push('/detail', extra: lotto);
      },
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${lotto.drwNo}회', style: h4),
                const SizedBox(width: 8),
                Text(lotto.drwNoDate, style: bodyM.copyWith(color: gray600)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children:
                  lotto.numbers.mapIndexed((index, number) {
                      return _latestRoundNumber(number: number);
                    }).toList()
                    ..add(const SvgIcon(asset: plusIcon, size: 20))
                    ..add(_latestRoundNumber(number: lotto.bnusNo)),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('총 당첨금  ', style: bodyS),
                      Text(lotto.firstAccumamnt.toWon(), style: h5),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('1게임 당첨금  ', style: bodyS),
                      Text(lotto.firstWinamnt.toWon(), style: h5),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('당첨자 수  ', style: bodyS),
                      Text('${lotto.firstPrzwnerCo}명', style: h5),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _latestRoundNumber({required int? number}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: number != null ? getLottoColor(number: number) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: subtitle1.copyWith(
                  color: gray25,
                  shadows: [
                    Shadow(
                      offset: const Offset(0.5, 0.5),
                      blurRadius: 2.0,
                      color: number != null ? gray400 : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
