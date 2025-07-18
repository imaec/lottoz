import 'package:data/datasource/local/lotto_local_data_source.dart';
import 'package:data/datasource/remote/lotto_remote_data_source.dart';
import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:domain/repository/lotto_repository.dart';

class LottoRepositoryImpl extends LottoRepository {
  final LottoRemoteDataSource _remoteDataSource;
  final LottoLocalDataSource _localDataSource;

  LottoRepositoryImpl({
    required LottoRemoteDataSource remoteDataSource,
    required LottoLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<LottoDto> getLottoNumber({required int drwNo}) {
    return _remoteDataSource.getLottoNumber(drwNo: drwNo);
  }

  @override
  Future<int> getCurDrwNo() {
    return _remoteDataSource.getCurDrwNo();
  }

  @override
  Future<int> getLocalCurDrwNo() {
    return _localDataSource.getCurDrwNo();
  }

  @override
  setLocalCurDrwNo(curDrwNo) {
    _localDataSource.setCurDrwNo(curDrwNo);
  }
}
