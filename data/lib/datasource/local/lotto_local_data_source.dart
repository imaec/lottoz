import 'package:data/data.dart';

abstract class LottoLocalDataSource {
  Future<int> getCurDrwNo();

  Future<int> setCurDrwNo({required int curDrwNo});

  Future<List<LottoEntity>> getLottoNumbers();

  Future<int> saveLottoNumbers({required List<LottoEntity> lottoNumbers});

  Future<List<MyLottoEntity>> getMyLottoNumbers();

  Future<int> saveMyLottoNumber({required MyLottoEntity myLottoNumber});

  Future<int> saveMyLottoNumbers({required List<MyLottoEntity> myLottoNumbers});

  Future<int> removeMyNumber({required int id});
}
