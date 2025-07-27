import 'package:intl/intl.dart';

extension IntExtension on int {
  String comma() {
    return NumberFormat('###,###,###,###').format(this);
  }

  String to100Million() {
    return (this / 100000000.0).round().toString();
  }

  String toWon() {
    if (this < 10000) return '만';

    final eok = this ~/ 100000000;         // 억 단위
    final man = (this % 100000000) ~/ 10000; // 만 단위

    final buffer = StringBuffer();
    if (eok > 0) buffer.write('$eok억');
    if (man > 0) buffer.write('${eok > 0 ? ' ' : ''}${man.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (match) => '${match[1]},')}만');

    return '${buffer.toString()}원';
  }
}

extension DoubleExtension on double {
  String comma() {
    return NumberFormat('###,###,###,###').format(this);
  }

  String to100Million() {
    return (this / 100000000.0).round().toString();
  }

  String toWon() {
    if (this < 10000) return '만';

    final eok = this ~/ 100000000;         // 억 단위
    final man = (this % 100000000) ~/ 10000; // 만 단위

    final buffer = StringBuffer();
    if (eok > 0) buffer.write('$eok억');
    if (man > 0) buffer.write('${eok > 0 ? ' ' : ''}${man.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (match) => '${match[1]},')}만');

    return '${buffer.toString()}원';
  }
}
