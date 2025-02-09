import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:quran_app/features/home/data/datasource/home_remote_dataSource.dart';
import 'package:quran_app/features/home/data/repository/home_repo_impl.dart';
import 'package:quran_app/features/home/domain/repository/home_repo.dart';
import 'package:quran_app/features/home/domain/usecase/get_surahDetails_usecase.dart';
import 'package:quran_app/features/home/domain/usecase/get_surah_usecase.dart';
import 'package:quran_app/features/home/presentation/controller/provider/home_provider.dart';

final getIt = GetIt.instance;

Future<void> initinjection() async {
  getIt
    ..registerLazySingleton(
      () => Dio(),
    );

  await homeInit();
}

Future<void> homeInit() async {
  getIt
    ..registerLazySingleton(
      () => GetSurahUsecase(homeRepo: getIt()),
    )..registerLazySingleton(() => GetSurahdetailsUsecase(homeRepo: getIt()),)
    ..registerLazySingleton<HomeRepo>(
      () => HomeRepoImpl(homeRemoteDatasource: getIt()),
    )
    ..registerLazySingleton<HomeRemoteDatasource>(
      () => HomeRemoteDatasourceImpl(),
    )
    ..registerLazySingleton<HomeProvider>(
      () => HomeProvider(),
    );
}
