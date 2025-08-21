
import 'package:app_mobile/features/splash_and_boarding/data/mapper/on_boarding_mapper.dart';
import 'package:app_mobile/features/splash_and_boarding/domain/model/on_boarding_model.dart';

import 'package:dartz/dartz.dart';
import '../../../../../core/error_handler/error_handler.dart';
import '../../../../../core/error_handler/failure.dart';
import '../../../../../core/internet_checker/interent_checker.dart';
import '../data_source/get_on_boarding_data_source.dart';

abstract class GetOnBoardingDataRepository {
  Future<Either<Failure, OnBoardingModel>> getOnBoardingData(
      );
}

class GetOnBoardingDataRepositoryImplement implements GetOnBoardingDataRepository {
  GetOnBoardingDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  GetOnBoardingDataRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, OnBoardingModel>> getOnBoardingData() async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.getOnBoardingData();
      return Right(response.toDomain());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
    // } else {
    //   return Left(
    //     Failure(
    //       ResponseCode.noInternetConnection,
    //       ManagerStrings.noInternetConnection,
    //     ),
    //   );
    // }
  }
}
