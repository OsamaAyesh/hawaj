import 'package:app_mobile/features/providers/job_provider_app/list_company_job/data/data_source/get_list_company_jobs_data_source.dart';
import 'package:app_mobile/features/providers/job_provider_app/list_company_job/data/mapper/get_list_company_jobs_mapper.dart';
import 'package:app_mobile/features/providers/job_provider_app/list_company_job/domain/models/get_list_company_jobs_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';

abstract class GetListCompanyJobsRepository {
  Future<Either<Failure, GetListCompanyJobsModel>> getListCompanyJobs();
}

class GetListCompanyJobsRepositoryImplement
    implements GetListCompanyJobsRepository {
  GetListCompanyJobsDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  GetListCompanyJobsRepositoryImplement(
      this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, GetListCompanyJobsModel>> getListCompanyJobs() async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.getListCompanyJobs();
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
