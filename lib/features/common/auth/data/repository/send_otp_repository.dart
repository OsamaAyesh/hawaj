
import 'package:app_mobile/features/common/auth/data/data_source/send_otp_data_source.dart';
import 'package:app_mobile/features/common/auth/data/mapper/send_otp_mapper.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/domain/model/send_otp_model.dart';

import 'package:dartz/dartz.dart';
import '../../../../../core/error_handler/error_handler.dart';
import '../../../../../core/error_handler/failure.dart';
import '../../../../../core/internet_checker/interent_checker.dart';

abstract class SendOtpRepository {
  Future<Either<Failure, SendOtpModel>> sendOtp(
      SendOtpRequest request,
      );
}

class SendOtpRepositoryImplement implements SendOtpRepository {
  SendOtpDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  SendOtpRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, SendOtpModel>> sendOtp(SendOtpRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.sendOtp(request);
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
