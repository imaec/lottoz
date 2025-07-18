import 'package:data/data.dart';

abstract class LottoLocalDataSource {
  Future<int> getCurDrwNo();

  setCurDrwNo({required int curDrwNo});

  Future<List<LottoEntity>> getLottoNumbers();

  Future<int> saveLottoNumbers({required List<LottoEntity> lottoNumbers});
}
