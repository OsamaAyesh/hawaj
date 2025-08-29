
import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/common/auth/data/data_source/send_otp_data_source.dart';
import 'package:app_mobile/features/common/auth/data/mapper/send_otp_mapper.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/domain/model/send_otp_model.dart';
import 'package:app_mobile/features/providers/offers_provider/add_offer/data/data_source/create_offer_provider_data_source.dart';
import 'package:app_mobile/features/providers/offers_provider/add_offer/data/request/create_offer_provider_request.dart';
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/data/data_source/get_my_offer_data_source.dart';
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/data/mapper/offer_mapper.dart';
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/domain/model/offer_model.dart';

import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';

abstract class GetMyOfferRepository {
  Future<Either<Failure, OfferModel>> getMyOfferData(
      );
}

class GetMyOfferRepositoryImplement implements GetMyOfferRepository {
  GetMyOfferDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  GetMyOfferRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, OfferModel>> getMyOfferData() async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.getMyOfferData();
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
