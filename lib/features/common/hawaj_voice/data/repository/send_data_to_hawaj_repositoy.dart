import 'package:app_mobile/features/common/hawaj_voice/data/mapper/send_data_mapper.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error_handler/error_handler.dart';
import '../../../../../core/error_handler/failure.dart';
import '../../../../../core/internet_checker/interent_checker.dart';
import '../../domain/models/send_data_model.dart';
import '../data_source/send_data_to_hawaj_data_source.dart';
import '../request/send_data_request.dart';

abstract class SendDataToHawajRepositoy {
  Future<Either<Failure, SendDataModel>> sendData(SendDataRequest request);
}

class SendDataToHawajRepositoyImplement implements SendDataToHawajRepositoy {
  SendDataToHawajDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  SendDataToHawajRepositoyImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, SendDataModel>> sendData(
      SendDataRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.sendData(request);
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
