
import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/common/auth/data/data_source/send_otp_data_source.dart';
import 'package:app_mobile/features/common/auth/data/data_source/verfiy_otp_data_source.dart';
import 'package:app_mobile/features/common/auth/data/mapper/send_otp_mapper.dart';
import 'package:app_mobile/features/common/auth/data/mapper/verfiy_otp_mapper.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/data/request/verfiy_otp_request.dart';
import 'package:app_mobile/features/common/auth/domain/model/send_otp_model.dart';
import 'package:app_mobile/features/common/auth/domain/model/verfiy_otp_model.dart';

import 'package:dartz/dartz.dart';
import '../../../../../core/error_handler/error_handler.dart';
import '../../../../../core/error_handler/failure.dart';
import '../../../../../core/internet_checker/interent_checker.dart';

abstract class VerfiyOtpRepository {
  Future<Either<Failure, VerfiyOtpModel>> verfiyOtp(
      VerfiyOtpRequest request,
      );
}

class VerfiyOtpRepositoryImplement implements VerfiyOtpRepository {
  VerfiyOtpDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  VerfiyOtpRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, VerfiyOtpModel>> verfiyOtp(VerfiyOtpRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.verfiyOtp(request);
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
