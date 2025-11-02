import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_company_jobs_provider/data/data_source/add_company_jobs_data_source.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_company_jobs_provider/data/request/add_company_jobs_request.dart';
import 'package:app_mobile/features/providers/job_provider_app/get_applications_job/data/data_source/get_job_applications_data_source.dart';
import 'package:app_mobile/features/providers/job_provider_app/get_applications_job/data/mapper/get_job_applications_mappers.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../../domain/models/get_job_applications_model.dart';
import '../request/get_job_applications_request.dart';

abstract class GetJobApplicationsRepository {
  Future<Either<Failure, GetJobApplicationsModel>> getJobApplications(
    GetJobApplicationRequest request,
  );
}

class GetJobApplicationsRepositoryImplement
    implements GetJobApplicationsRepository {
  GetJobApplicationsDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  GetJobApplicationsRepositoryImplement(
      this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, GetJobApplicationsModel>> getJobApplications(
      GetJobApplicationRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.getJobApplications(request);
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
