import 'package:designsystem/theme/colors.dart';
import 'package:flutter/material.dart';

Color getLottoColor({required int number}) {
  switch (number) {
    case >= 1 && <= 10:
      return lotto01_10;
    case >= 11 && <= 20:
      return lotto11_20;
    case >= 21 && <= 30:
      return lotto21_30;
    case >= 31 && <= 40:
      return lotto31_40;
    case >= 41 && <= 45:
      return lotto41_45;
    default:
      throw ArgumentError('로또 번호는 1~45 범위여야 합니다.');
  }
}
