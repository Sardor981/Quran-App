import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:quran_app/core/common/injections.dart';
import 'package:quran_app/core/common/utils/constants/network_constants.dart';
import 'package:quran_app/core/exeptions/custom_exeption.dart';
import 'package:quran_app/features/home/data/models/all_surah_model.dart';
import 'package:quran_app/features/home/data/models/surah_detail_model.dart';

abstract class HomeRemoteDatasource {
  Future<AllSurahModel?> getSurah();
  Future<SurahDetailModel?> getSurahDetails({required int surahId});
}
class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
  final dio = getIt<Dio>();

  @override
  Future<AllSurahModel?> getSurah() async {
    try {
      final response = await dio.get(NetworkConstants.allSurahUrl);
      if (response.statusCode == 200) {
        final result = response.data;
        log(result.toString());
        return AllSurahModel.fromJson(result);
      }
    } catch (e) {
      throw ServerExeption(
          errorMessage: "Error happened while fetching AllSurah",
          statusCode: 500);
    }
  }


  @override
  Future<SurahDetailModel?> getSurahDetails({required int surahId}) async {
    try {
      final response = await dio.get("${NetworkConstants.baseUrl}/surah/$surahId/ar.alafasy");
      if (response.statusCode == 200) {
        final result = response.data;
        log(result.toString());
        return SurahDetailModel.fromJson(result);
      }

    } catch (e) {
      throw ServerExeption(
          errorMessage: "Error while fetching Surah details", 
          statusCode: 500);
    }
    return null;
  }
}


