import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/data_source/delete_my_real_estate_data_source.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/request/delete_my_real_estate_request.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';

abstract class DeleteMyRealEstateRepository {
  Future<Either<Failure, WithOutDataModel>> deleteMyRealEstate(
    DeleteMyRealEstateRequest request,
  );
}

class DeleteMyRealEstateRepositoryImplement
    implements DeleteMyRealEstateRepository {
  DeleteMyRealEstateDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  DeleteMyRealEstateRepositoryImplement(
      this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, WithOutDataModel>> deleteMyRealEstate(
      DeleteMyRealEstateRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.deleteMyRealEstate(request);
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
