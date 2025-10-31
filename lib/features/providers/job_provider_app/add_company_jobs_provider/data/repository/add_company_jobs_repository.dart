import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_company_jobs_provider/data/data_source/add_company_jobs_data_source.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_company_jobs_provider/data/request/add_company_jobs_request.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';

abstract class AddCompanyJobsRepository {
  Future<Either<Failure, WithOutDataModel>> addCompany(
    AddCompanyJobsRequest request,
  );
}

class AddCompanyJobsRepositoryImplement implements AddCompanyJobsRepository {
  AddCompanyJobsDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  AddCompanyJobsRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, WithOutDataModel>> addCompany(
      AddCompanyJobsRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.addCompany(request);
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
