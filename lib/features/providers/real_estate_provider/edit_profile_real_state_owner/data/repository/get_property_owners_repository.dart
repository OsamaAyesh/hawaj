import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/data/data_source/get_property_owners_data_source.dart';
import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/data/mapper/get_property_owners_mapper.dart';
import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/data/request/get_property_owners_request.dart';
import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/domain/models/get_property_owners_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';

abstract class GetPropertyOwnersRepository {
  Future<Either<Failure, GetPropertyOwnersModel>> getMyPropertyOwners(
    GetPropertyOwnersRequest request,
  );
}

class GetPropertyOwnersRepositoryImplement
    implements GetPropertyOwnersRepository {
  GetPropertyOwnersDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  GetPropertyOwnersRepositoryImplement(
      this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, GetPropertyOwnersModel>> getMyPropertyOwners(
      GetPropertyOwnersRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.getMyPropertyOwners(request);
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
