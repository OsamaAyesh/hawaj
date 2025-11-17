import 'package:app_mobile/features/providers/offer_provider_new_api/details_my_organization/data/mapper/get_my_organization_details_mapper.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../../domain/models/get_my_organization_details_model.dart';
import '../data_source/get_my_organization_details_data_source.dart';
import '../request/get_my_organization_details_request.dart';

abstract class GetMyOrganizationDetailsRepository {
  Future<Either<Failure, GetMyOrganizationDetailsModel>>
      getMyOrganizationWithId(
    GetMyOrganizationDetailsRequest request,
  );
}

class GetMyOrganizationDetailsRepositoryImplement
    implements GetMyOrganizationDetailsRepository {
  GetMyOrganizationDetailsDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  GetMyOrganizationDetailsRepositoryImplement(
      this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, GetMyOrganizationDetailsModel>>
      getMyOrganizationWithId(GetMyOrganizationDetailsRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.getMyOrganizationWithId(request);
      return Right(response.toDomain());
    } catch (e) {
      print("في مشكلة عويصة");
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
