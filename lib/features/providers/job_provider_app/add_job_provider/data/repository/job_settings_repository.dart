import 'package:app_mobile/core/mapper/job_settings_mapper.dart';
import 'package:app_mobile/core/model/job_settings_model.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_job_provider/data/mapper/get_settings_base_mapper.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../../domain/models/get_settings_base_model.dart';
import '../data_source/job_settings_data_source.dart';

abstract class JobSettingsRepository {
  Future<Either<Failure, GetSettingsBaseModel>> getJobsSettings();
}

class JobSettingsRepositoryImplement implements JobSettingsRepository {
  JobSettingsDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  JobSettingsRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, GetSettingsBaseModel>> getJobsSettings() async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.getJobsSettings();
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
