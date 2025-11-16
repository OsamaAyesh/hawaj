import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error_handler/error_handler.dart';
import '../../../../../core/error_handler/failure.dart';
import '../../../../../core/internet_checker/interent_checker.dart';
import '../data_source/update_avatar_data_source.dart';
import '../request/update_avatar_request.dart';

abstract class UpdateAvatarRepository {
  Future<Either<Failure, WithOutDataModel>> updateAvatar(
    UpdateAvatarRequest request,
  );
}

class UpdateAvatarRepositoryImplement implements UpdateAvatarRepository {
  final UpdateAvatarDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  UpdateAvatarRepositoryImplement(
    this._networkInfo,
    this._remoteDataSource,
  );

  @override
  Future<Either<Failure, WithOutDataModel>> updateAvatar(
    UpdateAvatarRequest request,
  ) async {
    // if (await _networkInfo.isConnected) {
    try {
      final response = await _remoteDataSource.updateAvatar(request);
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
