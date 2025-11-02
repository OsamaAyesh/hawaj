import 'package:app_mobile/features/providers/job_provider_app/manager_jobs_provider/data/data_source/get_list_jobs_data_source.dart';
import 'package:app_mobile/features/providers/job_provider_app/manager_jobs_provider/data/mapper/get_list_jobs_mapper.dart';
import 'package:app_mobile/features/providers/job_provider_app/manager_jobs_provider/domain/models/get_list_jobs_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';

abstract class GetListJobsRepository {
  Future<Either<Failure, GetListJobsModel>> getListJobs();
}

class GetListJobsRepositoryImplement implements GetListJobsRepository {
  GetListJobsDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  GetListJobsRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, GetListJobsModel>> getListJobs() async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.getListJobs();
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
