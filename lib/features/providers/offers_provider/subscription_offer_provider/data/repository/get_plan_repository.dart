

import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/mapper/plan_mapper.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/domain/model/plan_model.dart';

import 'package:dartz/dartz.dart';
import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../data_source/get_plans_data_source.dart';

abstract class GetPlanRepository {
  Future<Either<Failure, PlanModel>> getPlansOfferProvider(
      );
}

class GetPlanRepositoryImplement implements GetPlanRepository {
  GetPlansDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  GetPlanRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, PlanModel>> getPlansOfferProvider() async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.getPlansOfferProvider();
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
