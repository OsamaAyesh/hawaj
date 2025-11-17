// delete_offer_repository.dart
import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../data_source/delete_offer_data_source.dart';
import '../request/delete_my_offer_request.dart';

abstract class DeleteOfferRepository {
  Future<Either<Failure, WithOutDataModel>> deleteMyOfferRequest(
    DeleteOfferRequest request,
  );
}

class DeleteOfferRepositoryImplement implements DeleteOfferRepository {
  final DeleteOfferDataSource remoteDataSource;
  final NetworkInfo _networkInfo;

  DeleteOfferRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, WithOutDataModel>> deleteMyOfferRequest(
      DeleteOfferRequest request) async {
    // if (await _networkInfo.isConnected) {
    try {
      final response = await remoteDataSource.deleteMyOfferRequest(request);
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
