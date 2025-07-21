part of 'statistics_screen.dart';

Widget _statisticsHeader({
  required StatisticsNotifier notifier,
  required int startRound,
  required int endRound,
  required int maxRound,
  Widget? rightWidget,
}) {
  return Builder(
    builder: (context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text('회차', style: bodyS),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    showNumberPicker(
                      context: context,
                      title: '회차 선택',
                      start: 1,
                      end: endRound,
                      initNumber: startRound,
                      onSelected: (number) {
                        notifier.setStartRound(startRound: number);
                      },
                    );
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: gray100),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Text('$startRound', style: subtitle2),
                        const SizedBox(width: 2),
                        const SvgIcon(asset: arrowDownIcon, size: 12),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('-', style: subtitle2),
                ),
                GestureDetector(
                  onTap: () {
                    showNumberPicker(
                      context: context,
                      title: '회차 선택',
                      start: startRound,
                      end: maxRound,
                      initNumber: endRound,
                      onSelected: (number) {
                        notifier.setEndRound(endRound: number);
                      },
                    );
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: gray100),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Text('$endRound', style: subtitle2),
                        const SizedBox(width: 2),
                        const SvgIcon(asset: arrowDownIcon, size: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            rightWidget ?? const SizedBox(),
          ],
        ),
      );
    },
  );
}
