import 'package:data/datasource/local/lotto_local_data_source.dart';
import 'package:data/datasource/remote/lotto_remote_data_source.dart';
import 'package:data/model/local/lotto/lotto_entity.dart';
import 'package:data/model/local/lotto/my_lotto_entity.dart';
import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:domain/model/lotto/lotto_win_price_dto.dart';
import 'package:domain/model/lotto/my_lotto_dto.dart';
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
  Future<int> getDatabaseCurDrwNo() {
    return _remoteDataSource.getDatabaseCurDrwNo();
  }

  @override
  Future<List<LottoDto>> getLottoNumbers() {
    return _remoteDataSource.getLottoNumbers();
  }

  @override
  Future<Map<int, List<StoreDto>>> getStores({required int drwNo}) {
    return _remoteDataSource.getStores(drwNo: drwNo);
  }

  @override
  Future<List<StoreDto>> getFirstStores({required int drwNo}) {
    return _remoteDataSource.getFirstStores(drwNo: drwNo);
  }

  @override
  Future<List<StoreDto>> getSecondStores({required int drwNo}) {
    return _remoteDataSource.getSecondStores(drwNo: drwNo);
  }

  @override
  Future<List<LottoWinPriceDto>> getWinPrices({required int drwNo}) {
    return _remoteDataSource.getWinPrices(drwNo: drwNo);
  }

  @override
  Future<void> saveLottoNumbersDatabase({required List<LottoDto> lottoNumbers}) {
    return _remoteDataSource.saveLottoNumbers(lottoNumbers: lottoNumbers);
  }

  /// local
  @override
  Future<int> getLocalCurDrwNo() {
    return _localDataSource.getCurDrwNo();
  }

  @override
  Future<int> setLocalCurDrwNo({required int curDrwNo}) {
    return _localDataSource.setCurDrwNo(curDrwNo: curDrwNo);
  }

  @override
  Future<List<LottoDto>> getLocalLottoNumbers() async {
    final lottoNumbers = await _localDataSource.getLottoNumbers();
    lottoNumbers.sort((prevNumber, nextNumber) => nextNumber.drwNo.compareTo(prevNumber.drwNo));
    return lottoNumbers.map((number) => number.mapper()).toList();
  }

  @override
  Future<int> saveLottoNumbersLocal({required List<LottoDto> lottoNumbers}) async {
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

  @override
  Future<List<MyLottoDto>> getMyLottoNumbers() async {
    final myLottoNumbers = await _localDataSource.getMyLottoNumbers();
    return myLottoNumbers.map((number) => number.mapper()).toList();
  }

  @override
  Future<int> saveMyLottoNumber({required MyLottoDto myLottoNumber}) async {
    return await _localDataSource.saveMyLottoNumber(
      myLottoNumber: MyLottoEntity(
        no1: myLottoNumber.no1,
        no2: myLottoNumber.no2,
        no3: myLottoNumber.no3,
        no4: myLottoNumber.no4,
        no5: myLottoNumber.no5,
        no6: myLottoNumber.no6,
      ),
    );
  }

  @override
  Future<int> saveMyLottoNumbers({required List<MyLottoDto> myLottoNumbers}) {
    return _localDataSource.saveMyLottoNumbers(
      myLottoNumbers: myLottoNumbers.map((lotto) {
        return MyLottoEntity(
          no1: lotto.no1,
          no2: lotto.no2,
          no3: lotto.no3,
          no4: lotto.no4,
          no5: lotto.no5,
          no6: lotto.no6,
        );
      }).toList(),
    );
  }

  @override
  Future<int> removeMyNumber({required int id}) async {
    return await _localDataSource.removeMyNumber(id: id);
  }
}
