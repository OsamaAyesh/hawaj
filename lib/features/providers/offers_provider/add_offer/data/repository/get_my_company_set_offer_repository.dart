import 'package:app_mobile/features/providers/offers_provider/add_offer/data/mapper/get_my_company_set_offer_mapper.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../../domain/model/get_my_company_set_offer_model.dart';
import '../data_source/get_my_company_set_offer_data_source.dart';
import '../request/get_my_company_set_offer_request.dart';

abstract class GetMyCompanySetOfferRepository {
  Future<Either<Failure, GetMyCompanySetOfferModel>> getMyCompanySetOffer(
    GetMyOrganizationSetOfferRequest request,
  );
}

class GetMyCompanySetOfferRepositoryImplement
    implements GetMyCompanySetOfferRepository {
  GetMyCompanySetOfferDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  GetMyCompanySetOfferRepositoryImplement(
      this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, GetMyCompanySetOfferModel>> getMyCompanySetOffer(
      GetMyOrganizationSetOfferRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.getMyCompanySetOffer(request);
      return Right(response.toDomain());
    } catch (e) {
      print("في مشكلة عويصة");
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
