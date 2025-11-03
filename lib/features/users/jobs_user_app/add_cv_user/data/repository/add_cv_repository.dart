import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/users/jobs_user_app/add_cv_user/data/data_source/add_cv_data_source.dart';
import 'package:app_mobile/features/users/jobs_user_app/add_cv_user/data/request/add_cv_request.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';

abstract class AddCvRepository {
  Future<Either<Failure, WithOutDataModel>> addCvRequest(AddCvRequest request);
}

class AddCvRepositoryImplement implements AddCvRepository {
  AddCvDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  AddCvRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, WithOutDataModel>> addCvRequest(
      AddCvRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.addCvRequest(request);
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
