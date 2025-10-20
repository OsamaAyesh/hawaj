import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/data_source/edit_my_real_estate_data_source.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/request/edit_my_real_estate_request.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';

abstract class EditMyRealEstateRepository {
  Future<Either<Failure, WithOutDataModel>> editRealEstate(
    EditMyRealEstateRequest request,
  );
}

class EditMyRealEstateRepositoryImplement
    implements EditMyRealEstateRepository {
  EditMyRealEstateDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  EditMyRealEstateRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, WithOutDataModel>> editRealEstate(
      EditMyRealEstateRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.editRealEstate(request);
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
