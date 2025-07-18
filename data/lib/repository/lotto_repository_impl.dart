import 'package:data/datasource/remote/lotto_remote_data_source.dart';
import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:domain/repository/lotto_repository.dart';

class LottoRepositoryImpl extends LottoRepository {
  final LottoRemoteDataSource _remoteDataSource;

  LottoRepositoryImpl({
    required LottoRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<LottoDto> getLottoNumber({required int drwNo}) {
    return _remoteDataSource.getLottoNumber(drwNo: drwNo);
  }
}
