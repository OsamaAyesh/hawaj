import 'package:app_mobile/features/users/offer_user/list_offers/data/mapper/get_organizations_mapper.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../../../../../providers/offers_provider/subscription_offer_provider/data/request/get_organizations_request.dart';
import '../../domain/models/get_organizations_model.dart';
import '../data_source/get_organizations_data_source.dart';

abstract class GetOrganizationsRepository {
  Future<Either<Failure, GetOrganizationsModel>> getOrganizations(
    GetOrganizationsRequest request,
  );
}

class GetOrganizationsRepositoryImplement
    implements GetOrganizationsRepository {
  GetOrganizationsDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  GetOrganizationsRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, GetOrganizationsModel>> getOrganizations(
      GetOrganizationsRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.getOrganizations(request);
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
