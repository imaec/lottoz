part of 'statistics_screen.dart';

enum NumberType {
  small, medium;
}

Widget _number({
  required int? number,
  NumberType numberType = NumberType.medium,
  Color? numberColor,
  Color? backgroundColor,
}) {
  return SizedBox(
    width: _getSize(numberType: numberType),
    height: _getSize(numberType: numberType),
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

double _getSize({required NumberType numberType}) {
  switch (numberType) {
    case NumberType.small:
      return 28;
    case NumberType.medium:
      return 30;
  }
}
