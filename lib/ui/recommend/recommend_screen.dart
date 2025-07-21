import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:designsystem/assets/icons.dart';
import 'package:designsystem/component/app_bar/lotto_app_bar.dart';
import 'package:designsystem/component/divider/horizontal_divider.dart';
import 'package:designsystem/component/media/svg_icon.dart';
import 'package:designsystem/component/number/number.dart';
import 'package:designsystem/component/picker/lotto_number_picker.dart';
import 'package:designsystem/component/snackbar/snackbar.dart';
import 'package:designsystem/theme/colors.dart';
import 'package:designsystem/theme/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottoz/ui/recommend/provider/recommend_notifier.dart';
import 'package:lottoz/ui/recommend/provider/recommend_state_provider.dart';

class RecommendScreen extends ConsumerWidget {
  const RecommendScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(recommendNotifierProvider.notifier);
    final state = ref.watch(recommendNotifierProvider);

    ref.listen(recommendNotifierProvider, (prev, next) {
      if (prev?.event != next.event) {
        if (next.event is ShowSnackBar) {
          showSnackBar(context: context, message: (next.event as ShowSnackBar).message);
          notifier.clearEvent();
        }
      }
    });

    return Scaffold(
      appBar: const LottoAppBar(title: '추천 번호'),
      body: _recommendBody(notifier: notifier, state: state),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 32),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  notifier.saveMyLottoNumbers();
                },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(color: gray700, borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Text('번호 저장', style: h5.copyWith(color: white)),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (state.includedNumbers.length < 6) {
                    notifier.createNumbers();
                  } else {
                    notifier.removeAllIncludedNumber();
                  }
                },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(color: gray700, borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Text(
                      state.includedNumbers.length < 6 ? '번호 생성' : '번호 삭제',
                      style: h5.copyWith(color: white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recommendBody({required RecommendNotifier notifier, required RecommendState state}) {
    return Column(
      children: [
        _statisticsSwitches(notifier: notifier, state: state),
        _recommendNumbers(notifier: notifier, state: state),
      ],
    );
  }

  Widget _statisticsSwitches({required RecommendNotifier notifier, required RecommendState state}) {
    return Column(
      children: [
        const SizedBox(height: 24),
        _statisticsSwitch(
          subject: '합계 적용',
          isChecked: state.isSumContains,
          onChanged: (isChecked) => notifier.toggleSumContains(isSumContains: isChecked),
        ),
        _statisticsSwitch(
          subject: '출현/미출현 적용',
          isChecked: state.isPickContains,
          onChanged: (isChecked) => notifier.togglePickContains(isPickContains: isChecked),
        ),
        _statisticsSwitch(
          subject: '홀/짝 적용',
          isChecked: state.isOddEvenContains,
          onChanged: (isChecked) => notifier.toggleOddEvenContains(isOddEvenContains: isChecked),
        ),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: HorizontalDivider()),
        _statisticsSwitch(
          subject: '전체 적용',
          isChecked: state.isAllContains,
          onChanged: (isChecked) => notifier.toggleAllContains(isAllContains: isChecked),
        ),
        const SizedBox(height: 24),
        const HorizontalDivider(),
      ],
    );
  }

  Widget _statisticsSwitch({
    required String subject,
    required bool isChecked,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(subject, style: bodyM),
          Switch(
            value: isChecked,
            activeTrackColor: gray700,
            inactiveThumbColor: gray700,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _recommendNumbers({required RecommendNotifier notifier, required RecommendState state}) {
    final unIncludedNumbers = state.unIncludedNumbers.sorted(
      (prevNumber, nextNumber) => prevNumber.compareTo(nextNumber),
    );
    final includedNumbers = List<int?>.generate(6 - state.includedNumbers.length, (i) => null)
      ..insertAll(0, state.includedNumbers.toList());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('포함하고 싶지 않은 번호', style: bodyM),
              Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      showNumberPicker(
                        context: context,
                        title: '번호 선택',
                        start: 1,
                        end: 45,
                        onSelected: (number) {
                          notifier.addUnIncludedNumber(number: number);
                        },
                      );
                    },
                    child: const SvgIcon(asset: plusIcon, size: 28),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: unIncludedNumbers.isNotEmpty ? 36 : 0,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: unIncludedNumbers.length,
              itemBuilder: (context, index) {
                final number = unIncludedNumbers[index];

                return GestureDetector(
                  onTap: () {
                    notifier.removeUnIncludedNumber(number: number);
                  },
                  child: lottoNumber(number: number, numberType: NumberType.big),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 6),
            ),
          ),
          const SizedBox(height: 32),
          Builder(
            builder: (context) {
              final itemWidth = (MediaQuery.of(context).size.width - 80) / 6;

              return SizedBox(
                height: itemWidth,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: includedNumbers.length,
                  itemBuilder: (context, index) {
                    final number = includedNumbers[index];

                    return _recommendNumber(
                      notifier: notifier,
                      number: number,
                      itemWidth: itemWidth,
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _recommendNumber({
    required RecommendNotifier notifier,
    required int? number,
    required double itemWidth,
  }) {
    return Builder(
      builder: (context) {
        return SizedBox(
          width: itemWidth,
          child: AspectRatio(
            aspectRatio: 1,
            child: GestureDetector(
              onTap: () {
                if (number != null) {
                  notifier.removeIncludedNumber(number: number);
                } else {
                  showNumberPicker(
                    context: context,
                    title: '번호 선택',
                    start: 1,
                    end: 45,
                    onSelected: (number) {
                      notifier.addIncludedNumber(number: number);
                    },
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: number == null ? white : getLottoColor(number: number),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: number == null ? gray700 : getLottoColor(number: number),
                  ),
                ),
                child: Center(
                  child: Text(
                    '${number ?? ''}',
                    style: subtitle1.copyWith(color: number == null ? gray800 : white),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
