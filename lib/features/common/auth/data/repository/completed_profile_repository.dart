
import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/common/auth/data/data_source/completed_profile_data_source.dart';
import 'package:app_mobile/features/common/auth/data/data_source/send_otp_data_source.dart';
import 'package:app_mobile/features/common/auth/data/mapper/send_otp_mapper.dart';
import 'package:app_mobile/features/common/auth/data/request/completed_profile_request.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/domain/model/send_otp_model.dart';

import 'package:dartz/dartz.dart';
import '../../../../../core/error_handler/error_handler.dart';
import '../../../../../core/error_handler/failure.dart';
import '../../../../../core/internet_checker/interent_checker.dart';

abstract class CompletedProfileRepository {
  Future<Either<Failure, WithOutDataModel>> completedProfile(
      CompletedProfileRequest request,
      );
}

class CompletedProfileRepositoryImplement implements CompletedProfileRepository {
  CompletedProfileDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  CompletedProfileRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, WithOutDataModel>> completedProfile(CompletedProfileRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.completedProfile(request);
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
