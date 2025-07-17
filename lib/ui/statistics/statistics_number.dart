part of 'statistics_screen.dart';

Widget _number({
  required int? number,
  Color? numberColor,
  Color? backgroundColor,
}) {
  return SizedBox(
    width: 30,
    height: 30,
    child: Container(
      decoration: BoxDecoration(
        color: number != null
            ? (backgroundColor ?? getLottoColor(number: number))
            : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$number',
          style: subtitle4.copyWith(
            color: numberColor ?? gray25,
            shadows: [
              Shadow(
                offset: const Offset(0.5, 0.5),
                blurRadius: 2.0,
                color: number != null && backgroundColor != Colors.transparent
                    ? gray400
                    : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
