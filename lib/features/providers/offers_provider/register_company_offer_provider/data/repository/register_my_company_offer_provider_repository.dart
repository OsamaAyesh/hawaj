
import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/common/auth/data/data_source/send_otp_data_source.dart';
import 'package:app_mobile/features/common/auth/data/mapper/send_otp_mapper.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/domain/model/send_otp_model.dart';

import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../data_source/register_my_company_offer_provider_data_source.dart';
import '../request/register_my_company_offer_provider_request.dart';

abstract class RegisterMyCompanyOfferProviderRepository {
  Future<Either<Failure, WithOutDataModel>> registerMyCompanyOfferProvider(
      RegisterMyCompanyOfferProviderRequest request,
      );
}

class RegisterMyCompanyOfferProviderRepositoryImplement implements RegisterMyCompanyOfferProviderRepository {
  RegisterMyCompanyOfferProviderDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  RegisterMyCompanyOfferProviderRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, WithOutDataModel>> registerMyCompanyOfferProvider(RegisterMyCompanyOfferProviderRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.registerMyCompanyOfferProvider(request);
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
