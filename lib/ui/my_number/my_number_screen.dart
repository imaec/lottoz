import 'package:core/utils/lotto_utils.dart';
import 'package:designsystem/assets/icons.dart';
import 'package:designsystem/component/app_bar/lotto_app_bar.dart';
import 'package:designsystem/component/divider/horizontal_divider.dart';
import 'package:designsystem/component/media/svg_icon.dart';
import 'package:designsystem/component/snackbar/snackbar.dart';
import 'package:designsystem/theme/colors.dart';
import 'package:designsystem/theme/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottoz/model/lotto/my_lotto_vo.dart';
import 'package:lottoz/ui/my_number/provider/my_number_notifier.dart';
import 'package:lottoz/ui/my_number/provider/my_number_state_provider.dart';

class MyNumberScreen extends ConsumerStatefulWidget {
  const MyNumberScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MyNumberScreenState();
}

class MyNumberScreenState extends ConsumerState<MyNumberScreen> {
  @override
  void initState() {
    ref.read(myNumberNotifierProvider.notifier).fetchLottoNumbers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(myNumberNotifierProvider.notifier);
    final state = ref.watch(myNumberNotifierProvider);

    ref.listen(myNumberNotifierProvider, (prev, next) {
      if (prev?.event != next.event) {
        if (next.event is ShowSnackBar) {
          showSnackBar(context: context, message: (next.event as ShowSnackBar).message);
          notifier.clearEvent();
        }
      }
    });

    return Scaffold(
      appBar: LottoAppBar(
        title: '내 번호',
        topPadding: MediaQuery.of(context).padding.top,
        hasBack: true,
      ),
      body: _myNumberBody(
        context: context,
        notifier: notifier,
        myLottoNumbers: state.myLottoNumbers,
      ),
    );
  }

  Widget _myNumberBody({
    required BuildContext context,
    required MyNumberNotifier notifier,
    required List<MyLottoVo> myLottoNumbers,
  }) {
    final mediaQuery = MediaQuery.of(context);

    return ListView.separated(
      padding: EdgeInsets.only(top: 8, bottom: mediaQuery.padding.bottom),
      itemCount: myLottoNumbers.length,
      itemBuilder: (context, index) {
        final myLotto = myLottoNumbers[index];
        final itemWidth = (mediaQuery.size.width - 80) / 6;

        return Slidable(
          key: ValueKey(myLotto.id),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: 0.2,
            children: [
              CustomSlidableAction(
                onPressed: (context) {
                  notifier.removeMyNumber(id: myLotto.id);
                },
                backgroundColor: error,
                foregroundColor: white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SvgIcon(asset: deleteIcon, size: 20, color: white),
                    const SizedBox(height: 4),
                    Text('삭제', style: subtitle4.copyWith(color: white)),
                  ],
                ),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              // todo : 역대 당첨 결과 화면으로 이동
            },
            child: Stack(
              children: [
                SizedBox(
                  height: itemWidth + 32,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final number = myLotto.numbers[index];
                      final isFit = myLotto.checkFit[number] ?? false;

                      return _myNumber(
                        number: number,
                        isFit: isFit,
                        noBonus: myLotto.noBonus,
                        itemWidth: itemWidth,
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                  ),
                ),
                myLotto.rank != null
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: gray700.withValues(alpha: 0.7),
                          borderRadius: const BorderRadius.only(bottomRight: Radius.circular(16)),
                        ),
                        child: Text('${myLotto.rank}등', style: subtitle2.copyWith(color: white)),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const HorizontalDivider();
      },
    );
  }

  Widget _myNumber({
    required int number,
    required bool isFit,
    required int noBonus,
    required double itemWidth,
  }) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 16),
          width: itemWidth,
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: getLottoColor(number: number),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text('$number', style: subtitle1.copyWith(color: white)),
              ),
            ),
          ),
        ),
        isFit || number == noBonus
            ? SizedBox(
                width: itemWidth,
                child: Column(
                  children: [
                    const Spacer(),
                    Container(
                      width: itemWidth / 3,
                      height: 3,
                      color: number == noBonus ? bonusRed : gray800,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
