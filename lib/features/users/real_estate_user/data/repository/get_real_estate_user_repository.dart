import 'package:app_mobile/features/users/real_estate_user/data/data_source/get_real_estate_user_data_source.dart';
import 'package:app_mobile/features/users/real_estate_user/data/mapper/get_real_estate_user_mapper.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../../domain/models/get_real_estate_user_model.dart';
import '../request/get_real_estate_user_request.dart';

abstract class GetRealEstateUserRepository {
  Future<Either<Failure, GetRealEstateUserModel>> getMyRealUserEstate(
    GetRealEstateUserRequest request,
  );
}

class GetRealEstateUserRepositoryImplement
    implements GetRealEstateUserRepository {
  GetRealEstateUserDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  GetRealEstateUserRepositoryImplement(
      this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, GetRealEstateUserModel>> getMyRealUserEstate(
      GetRealEstateUserRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.getMyRealUserEstate(request);
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
