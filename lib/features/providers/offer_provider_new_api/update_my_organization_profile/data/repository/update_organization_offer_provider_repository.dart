import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../data_source/update_organization_offer_provider_data_source.dart';
import '../request/update_organization_offer_provider_request.dart';

abstract class UpdateOrganizationOfferProviderRepository {
  Future<Either<Failure, WithOutDataModel>> updateOrganizationOfferProvider(
    UpdateOrganizationOfferProviderRequest request,
  );
}

class UpdateOrganizationOfferProviderRepositoryImplement
    implements UpdateOrganizationOfferProviderRepository {
  final UpdateOrganizationOfferProviderDataSource remoteDataSource;
  final NetworkInfo _networkInfo;

  UpdateOrganizationOfferProviderRepositoryImplement(
      this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, WithOutDataModel>> updateOrganizationOfferProvider(
      UpdateOrganizationOfferProviderRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response =
          await remoteDataSource.updateOrganizationOfferProvider(request);
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
