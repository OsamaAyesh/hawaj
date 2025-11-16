import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../data_source/add_offer_new_data_source.dart';
import '../request/add_offer_new_request.dart';

abstract class AddOfferNewRepository {
  Future<Either<Failure, WithOutDataModel>> addOfferNewRequest(
    AddOfferNewRequest request,
  );
}

class AddOfferNewRepositoryImplement implements AddOfferNewRepository {
  AddOfferNewDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  AddOfferNewRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, WithOutDataModel>> addOfferNewRequest(
      AddOfferNewRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.addOfferNewRequest(request);
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
