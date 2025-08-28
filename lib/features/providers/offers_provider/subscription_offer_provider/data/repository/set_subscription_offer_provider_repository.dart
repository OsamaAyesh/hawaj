

import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/data_source/set_subscription_offer_provider_data_source.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/mapper/plan_mapper.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/request/set_subscription_offer_provider_request.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/domain/model/plan_model.dart';

import 'package:dartz/dartz.dart';
import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../data_source/get_plans_data_source.dart';

abstract class SetSubscriptionOfferProviderRepository {
  Future<Either<Failure, WithOutDataModel>> setSubscriptionOfferProvider(
      SetSubscriptionOfferProviderRequest request
      );
}

class SetSubscriptionOfferProviderRepositoryImplement implements SetSubscriptionOfferProviderRepository {
  SetSubscriptionOfferProviderDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  SetSubscriptionOfferProviderRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, WithOutDataModel>> setSubscriptionOfferProvider(
      SetSubscriptionOfferProviderRequest request
      ) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.setSubscriptionOfferProvider(request);
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
