import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/mapper/get_my_organization_offer_provider_mapper.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/mapper/plan_mapper.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/domain/model/get_my_organization_offer_provider_model.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/domain/model/plan_model.dart';

import 'package:dartz/dartz.dart';
import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../data_source/get_my_organization_offer_provider_data_source.dart';
import '../data_source/get_plans_data_source.dart';
import '../request/get_organizations_request.dart';

abstract class GetMyOrganizationOfferProviderRepository {
  Future<Either<Failure, GetMyOrganizationOfferProviderModel>>
      getMyOrganizations(GetOrganizationsRequest request);
}

class GetMyOrganizationOfferProviderRepositoryImplement
    implements GetMyOrganizationOfferProviderRepository {
  GetMyOrganizationOfferProviderDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  GetMyOrganizationOfferProviderRepositoryImplement(
      this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, GetMyOrganizationOfferProviderModel>>
      getMyOrganizations(GetOrganizationsRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.getMyOrganizations(request);
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
