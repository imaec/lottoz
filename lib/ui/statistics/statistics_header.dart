part of 'statistics_screen.dart';

Widget _statisticsHeader({
  Widget? rightWidget
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text('회차', style: bodyS),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: gray100),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                children: [
                  Text('1', style: subtitle2),
                  SizedBox(width: 2),
                  SvgIcon(asset: arrowDownIcon, size: 12),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('-', style: subtitle2),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: gray100),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                children: [
                  Text('1180', style: subtitle2),
                  SizedBox(width: 2),
                  SvgIcon(asset: arrowDownIcon, size: 12),
                ],
              ),
            ),
          ],
        ),
        rightWidget ?? const SizedBox(),
      ],
    ),
  );
}
