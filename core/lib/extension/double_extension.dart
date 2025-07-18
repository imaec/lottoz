import 'package:intl/intl.dart';

extension DoubleExtension on double {
  String comma() {
    return NumberFormat('###,###,###,###').format(this);
  }

  String to100Million() {
    return (this / 100000000.0).round().toString();
  }
}
