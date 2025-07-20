import 'package:core/utils/lotto_utils.dart';
import 'package:designsystem/component/app_bar/lotto_app_bar.dart';
import 'package:designsystem/component/divider/horizontal_divider.dart';
import 'package:designsystem/theme/colors.dart';
import 'package:designsystem/theme/fonts.dart';
import 'package:flutter/material.dart';

class MyNumberScreen extends StatelessWidget {
  const MyNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LottoAppBar(
        title: '내 번호',
        topPadding: MediaQuery.of(context).padding.top,
        hasBack: true,
      ),
      body: _myNumberBody(context: context),
    );
  }

  Widget _myNumberBody({required BuildContext context}) {
    final mediaQuery = MediaQuery.of(context);
    final numbers = [1, 12, 24, 42, 44, 45];

    return ListView.separated(
      padding: EdgeInsets.only(top: 8, bottom: mediaQuery.padding.bottom),
      itemCount: 10,
      itemBuilder: (context, index) {
        final itemWidth = (mediaQuery.size.width - 80) / 6;

        return SizedBox(
          height: itemWidth + 32,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: numbers.length,
            itemBuilder: (context, index) {
              final number = numbers[index];

              return _myNumber(number: number, itemWidth: itemWidth);
            },
            separatorBuilder: (context, index) => const SizedBox(width: 8),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const HorizontalDivider();
      },
    );
  }

  Widget _myNumber({required int number, required double itemWidth}) {
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
        SizedBox(
          width: itemWidth,
          child: Column(
            children: [
              const Spacer(),
              Container(width: itemWidth / 3, height: 3, color: gray800),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
