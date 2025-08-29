
import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/common/auth/data/data_source/send_otp_data_source.dart';
import 'package:app_mobile/features/common/auth/data/mapper/send_otp_mapper.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/domain/model/send_otp_model.dart';
import 'package:app_mobile/features/common/profile/data/data_source/update_avatar_data_source.dart';
import 'package:app_mobile/features/common/profile/data/data_source/update_profile_data_source.dart';
import 'package:app_mobile/features/common/profile/data/request/update_avatar_request.dart';
import 'package:app_mobile/features/common/profile/data/request/update_profile_request.dart';

import 'package:dartz/dartz.dart';
import '../../../../../core/error_handler/error_handler.dart';
import '../../../../../core/error_handler/failure.dart';
import '../../../../../core/internet_checker/interent_checker.dart';

abstract class UpdateAvatarRepository {
  Future<Either<Failure, WithOutDataModel>> updateAvatar(
      UpdateAvatarRequest request,
      );
}

class UpdateAvatarRepositoryImplement implements UpdateAvatarRepository {
  UpdateAvatarDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  UpdateAvatarRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, WithOutDataModel>> updateAvatar(UpdateAvatarRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.updateAvatar(request);
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
