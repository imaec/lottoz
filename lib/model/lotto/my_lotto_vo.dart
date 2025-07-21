import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:domain/model/lotto/my_lotto_dto.dart';

class MyLottoVo {
  final int id;
  final int no1;
  final int no2;
  final int no3;
  final int no4;
  final int no5;
  final int no6;
  final int noBonus;
  final Map<int, bool> checkFit;
  final int? rank;

  MyLottoVo({
    required this.id,
    required this.no1,
    required this.no2,
    required this.no3,
    required this.no4,
    required this.no5,
    required this.no6,
    required this.noBonus,
    required this.checkFit,
    required this.rank,
  });

  List<int> get numbers => [no1, no2, no3, no4, no5, no6];
}

extension MyLottoDtoExtension on MyLottoDto {
  MyLottoVo toVo({required LottoDto lotto}) {
    final checkFit = {
      no1: lotto.numbers.contains(no1),
      no2: lotto.numbers.contains(no2),
      no3: lotto.numbers.contains(no3),
      no4: lotto.numbers.contains(no4),
      no5: lotto.numbers.contains(no5),
      no6: lotto.numbers.contains(no6),
    };
    final fitCount = checkFit.values.toList().where((e) {
      return e;
    }).length;

    return MyLottoVo(
      id: id ?? -1,
      no1: no1,
      no2: no2,
      no3: no3,
      no4: no4,
      no5: no5,
      no6: no6,
      noBonus: lotto.bnusNo,
      checkFit: checkFit,
      rank: _getRank(fitCount: fitCount, isBonusFit: numbers.contains(lotto.bnusNo)),
    );
  }

  int? _getRank({required int fitCount, required bool isBonusFit}) {
    switch (fitCount) {
      case 6:
        return 1;
      case 5:
        if (isBonusFit) {
          return 2;
        } else {
          return 3;
        }
      case 4:
        return 4;
      case 3:
        return 5;
      default:
        return null;
    }
  }
}
