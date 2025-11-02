import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_job_provider/data/data_source/add_job_data_source.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_job_provider/data/request/add_job_request.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';

abstract class AddJobRepository {
  Future<Either<Failure, WithOutDataModel>> addJobRequest(
      AddJobRequest request);
}

class AddJobRepositoryImplement implements AddJobRepository {
  AddJobDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  AddJobRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, WithOutDataModel>> addJobRequest(
      AddJobRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.addJobRequest(request);
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
