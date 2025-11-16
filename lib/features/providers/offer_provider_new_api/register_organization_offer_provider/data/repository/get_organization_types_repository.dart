import 'package:app_mobile/features/providers/offer_provider_new_api/register_organization_offer_provider/data/mapper/get_organization_types_mapper.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../../domain/models/get_organization_types_model.dart';
import '../data_source/get_organization_types_data_source.dart';
import '../request/get_organization_types_request.dart';

abstract class GetOrganizationTypesRepository {
  Future<Either<Failure, GetOrganizationTypesModel>> getOrganizationTypes(
    GetOrganizationTypesRequest request,
  );
}

class GetOrganizationTypesRepositoryImplement
    implements GetOrganizationTypesRepository {
  GetOrganizationTypesDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  GetOrganizationTypesRepositoryImplement(
      this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, GetOrganizationTypesModel>> getOrganizationTypes(
      GetOrganizationTypesRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.getOrganizationTypes(request);
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
