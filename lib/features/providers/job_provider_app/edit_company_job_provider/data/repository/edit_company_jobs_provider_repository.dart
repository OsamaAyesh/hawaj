import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/providers/job_provider_app/edit_company_job_provider/data/data_source/edit_company_jobs_provider_data_source.dart';
import 'package:app_mobile/features/providers/job_provider_app/edit_company_job_provider/data/request/edit_company_jobs_provider_request.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';

abstract class EditCompanyJobsProviderRepository {
  Future<Either<Failure, WithOutDataModel>> editCompanyJobsProvider(
    EditCompanyJobsProviderRequest request,
  );
}

class EditCompanyJobsProviderRepositoryImplement
    implements EditCompanyJobsProviderRepository {
  EditCompanyJobsProviderDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  EditCompanyJobsProviderRepositoryImplement(
      this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, WithOutDataModel>> editCompanyJobsProvider(
      EditCompanyJobsProviderRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.editCompanyJobsProvider(request);
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
