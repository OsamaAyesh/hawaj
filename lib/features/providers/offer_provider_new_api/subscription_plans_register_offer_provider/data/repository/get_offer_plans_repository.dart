import 'package:app_mobile/features/providers/offer_provider_new_api/subscription_plans_register_offer_provider/data/mapper/get_offer_plans_mapper.dart';
import 'package:app_mobile/features/providers/offer_provider_new_api/subscription_plans_register_offer_provider/domain/models/get_offer_plans_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../data_source/get_offer_plans_data_source.dart';
import '../request/get_offer_provider_plans_request.dart';

abstract class GetOfferPlansRepository {
  Future<Either<Failure, GetOfferPlansModel>> getOfferProviderPlans(
    GetOfferProviderPlansRequest request,
  );
}

class GetOfferPlansRepositoryImplement implements GetOfferPlansRepository {
  GetOfferPlansDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  GetOfferPlansRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, GetOfferPlansModel>> getOfferProviderPlans(
      GetOfferProviderPlansRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.getOfferProviderPlans(request);
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
