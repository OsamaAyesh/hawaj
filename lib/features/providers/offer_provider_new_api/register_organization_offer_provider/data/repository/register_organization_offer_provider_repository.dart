import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../data_source/register_organization_offer_provider_data_source.dart';
import '../request/register_organization_offer_provider_request.dart';

abstract class RegisterOrganizationOfferProviderRepository {
  Future<Either<Failure, WithOutDataModel>> registerOrganizationOfferProvider(
    RegisterOrganizationOfferProviderRequest request,
  );
}

class RegisterOrganizationOfferProviderRepositoryImplement
    implements RegisterOrganizationOfferProviderRepository {
  RegisterOrganizationOfferProviderDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  RegisterOrganizationOfferProviderRepositoryImplement(
      this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, WithOutDataModel>> registerOrganizationOfferProvider(
      RegisterOrganizationOfferProviderRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response =
          await remoteDataSource.registerOrganizationOfferProvider(request);
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
