
import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/common/auth/data/data_source/send_otp_data_source.dart';
import 'package:app_mobile/features/common/auth/data/mapper/send_otp_mapper.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/domain/model/send_otp_model.dart';
import 'package:app_mobile/features/common/profile/data/data_source/get_profile_data_source.dart';
import 'package:app_mobile/features/common/profile/data/data_source/update_avatar_data_source.dart';
import 'package:app_mobile/features/common/profile/data/data_source/update_profile_data_source.dart';
import 'package:app_mobile/features/common/profile/data/mapper/get_profile_mapper.dart';
import 'package:app_mobile/features/common/profile/data/request/update_avatar_request.dart';
import 'package:app_mobile/features/common/profile/data/request/update_profile_request.dart';
import 'package:app_mobile/features/common/profile/domain/model/get_profile_model.dart';

import 'package:dartz/dartz.dart';
import '../../../../../core/error_handler/error_handler.dart';
import '../../../../../core/error_handler/failure.dart';
import '../../../../../core/internet_checker/interent_checker.dart';

abstract class GetProfileRepository {
  Future<Either<Failure, GetProfileModel>> getProfile(
      );
}

class GetProfileRepositoryImplement implements GetProfileRepository {
  GetProfileDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  GetProfileRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, GetProfileModel>> getProfile() async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.getProfile();
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
