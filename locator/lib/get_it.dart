import 'package:data/data.dart';
import 'package:data/repository/setting_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:local/data_source/lotto_local_data_source_impl.dart';
import 'package:local/data_source/setting_local_data_source_impl.dart';
import 'package:remote/datasource/lotto_remote_data_source_impl.dart';
import 'package:remote/service/lotto_service.dart';

final locator = GetIt.instance;

initLocator() {
  _networkModule();
  _lottoModule();
  _settingModule();
}

_networkModule() {
  BaseOptions options = BaseOptions(
    baseUrl: 'https://www.dhlottery.co.kr/',
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  );
  final dio = Dio(options);
  dio.interceptors.add(LogInterceptor(requestBody: kDebugMode, responseBody: kDebugMode));
  locator.registerLazySingleton(() => dio);
}

_lottoModule() {
  locator.registerLazySingleton<LottoService>(() => LottoService(locator()));
  locator.registerLazySingleton<LottoRemoteDataSource>(
    () => LottoRemoteDataSourceImpl(service: locator()),
  );
  locator.registerLazySingleton<LottoLocalDataSource>(() => LottoLocalDataSourceImpl());
  locator.registerLazySingleton<LottoRepository>(
    () => LottoRepositoryImpl(remoteDataSource: locator(), localDataSource: locator()),
  );
}

_settingModule() {
  locator.registerLazySingleton<SettingLocalDataSource>(() => SettingLocalDataSourceImpl());
  locator.registerLazySingleton<SettingRepository>(
    () => SettingRepositoryImpl(localDataSource: locator()),
  );
}
