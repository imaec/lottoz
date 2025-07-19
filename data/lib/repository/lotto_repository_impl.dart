import 'package:data/datasource/local/lotto_local_data_source.dart';
import 'package:data/datasource/remote/lotto_remote_data_source.dart';
import 'package:data/model/local/lotto/lotto_entity.dart';
import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:domain/model/lotto/store_dto.dart';
import 'package:domain/repository/lotto_repository.dart';

class LottoRepositoryImpl extends LottoRepository {
  final LottoRemoteDataSource _remoteDataSource;
  final LottoLocalDataSource _localDataSource;

  LottoRepositoryImpl({
    required LottoRemoteDataSource remoteDataSource,
    required LottoLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  /// remote
  @override
  Future<LottoDto> getLottoNumber({required int drwNo}) {
    return _remoteDataSource.getLottoNumber(drwNo: drwNo);
  }

  @override
  Future<int> getCurDrwNo() {
    return _remoteDataSource.getCurDrwNo();
  }

  @override
  Future<List<StoreDto>> getStores({required int drwNo}) {
    return _remoteDataSource.getStores(drwNo: drwNo);
  }

  /// local
  @override
  Future<int> getLocalCurDrwNo() {
    return _localDataSource.getCurDrwNo();
  }

  @override
  setLocalCurDrwNo({required int curDrwNo}) {
    _localDataSource.setCurDrwNo(curDrwNo: curDrwNo);
  }

  @override
  Future<List<LottoDto>> getLottoNumbers() async {
    final lottoNumbers = await _localDataSource.getLottoNumbers();
    lottoNumbers.sort((prevNumber, nextNumber) => nextNumber.drwNo.compareTo(prevNumber.drwNo));
    return lottoNumbers.map((number) => number.mapper()).toList();
  }

  @override
  Future<int> saveLottoNumbers({required List<LottoDto> lottoNumbers}) async {
    return await _localDataSource.saveLottoNumbers(
      lottoNumbers: lottoNumbers.map((lotto) {
        return LottoEntity(
          bnusNo: lotto.bnusNo,
          drwNo: lotto.drwNo,
          drwNoDate: lotto.drwNoDate,
          drwtNo1: lotto.drwtNo1,
          drwtNo2: lotto.drwtNo2,
          drwtNo3: lotto.drwtNo3,
          drwtNo4: lotto.drwtNo4,
          drwtNo5: lotto.drwtNo5,
          drwtNo6: lotto.drwtNo6,
          firstAccumamnt: lotto.firstAccumamnt,
          firstPrzwnerCo: lotto.firstPrzwnerCo,
          firstWinamnt: lotto.firstWinamnt,
          totSellamnt: lotto.totSellamnt,
        );
      }).toList(),
    );
  }
}
