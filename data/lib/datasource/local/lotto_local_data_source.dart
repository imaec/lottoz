import 'package:data/data.dart';

abstract class LottoLocalDataSource {
  Future<int> getCurDrwNo();

  Future<int> setCurDrwNo({required int curDrwNo});

  Future<List<LottoEntity>> getLottoNumbers();

  Future<int> saveLottoNumbers({required List<LottoEntity> lottoNumbers});
}
