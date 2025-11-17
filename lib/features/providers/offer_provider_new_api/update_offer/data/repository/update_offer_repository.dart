// update_offer_repository.dart
import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../data_source/update_offer_data_source.dart';
import '../request/update_offer_request.dart';

abstract class UpdateOfferRepository {
  Future<Either<Failure, WithOutDataModel>> updateOfferRequest(
    UpdateOfferRequest request,
  );
}

class UpdateOfferRepositoryImplement implements UpdateOfferRepository {
  final UpdateOfferDataSource remoteDataSource;
  final NetworkInfo _networkInfo;

  UpdateOfferRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, WithOutDataModel>> updateOfferRequest(
      UpdateOfferRequest request) async {
    // if (await _networkInfo.isConnected) {
    try {
      final response = await remoteDataSource.updateOfferRequest(request);
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
