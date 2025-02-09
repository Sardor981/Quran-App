import 'package:dartz/dartz.dart';
import 'package:quran_app/core/exeptions/custom_exeption.dart';
import 'package:quran_app/features/home/data/datasource/home_remote_dataSource.dart';
import 'package:quran_app/features/home/data/mappers/all_surah_mapper.dart';
import 'package:quran_app/features/home/data/mappers/surah_details_mapper.dart'; // Assuming you have a separate mapper for SurahDetails
import 'package:quran_app/features/home/domain/entity/all_surah_entity.dart';
import 'package:quran_app/features/home/domain/entity/surah_details_entity.dart';
import 'package:quran_app/features/home/domain/repository/home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDatasource homeRemoteDatasource;

  HomeRepoImpl({required this.homeRemoteDatasource});

  @override
  Future<Either<String, AllSurahEntity>> getSurah() async {
    try {
      final result = await homeRemoteDatasource.getSurah();
      return Right(AllSurahMapper.mapSurahEntity(result));
    } on ServerExeption catch (e) {
      return Left(e.errorMessage);
    } catch (e) {
      return Left('An unexpected error occurred');
    }
  }

  @override
  Future<Either<String, SurahDetailEntity>> getSurahDetails({required int surahId}) async {
    try {
      final result = await homeRemoteDatasource.getSurahDetails(surahId: surahId);
      return Right(SurahDetailsMapper.mapSurahDetails(result)); 
    } on ServerExeption catch (e) {
      return Left(e.errorMessage);
    } catch (e) {
      return Left('An unexpected error occurred');
    }
  }
}