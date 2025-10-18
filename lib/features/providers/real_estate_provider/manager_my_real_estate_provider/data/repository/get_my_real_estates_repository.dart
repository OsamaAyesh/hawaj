import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/data_source/get_my_real_estates_data_source.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/mapper/get_my_real_estates_mapper.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../../domain/models/get_my_real_estates_model.dart';
import '../request/get_my_real_estates_request.dart';

abstract class GetMyRealEstatesRepository {
  Future<Either<Failure, GetMyRealEstatesModel>> getMyRealEstate(
    GetMyRealEstatesRequest request,
  );
}

class GetMyRealEstatesRepositoryImplement
    implements GetMyRealEstatesRepository {
  GetMyRealEstatesDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  GetMyRealEstatesRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, GetMyRealEstatesModel>> getMyRealEstate(
      GetMyRealEstatesRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.getMyRealEstate(request);
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
