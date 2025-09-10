
import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/common/auth/data/data_source/send_otp_data_source.dart';
import 'package:app_mobile/features/common/auth/data/mapper/send_otp_mapper.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/domain/model/send_otp_model.dart';
import 'package:app_mobile/features/providers/offers_provider/add_offer/data/data_source/create_offer_provider_data_source.dart';
import 'package:app_mobile/features/providers/offers_provider/add_offer/data/request/create_offer_provider_request.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/data/data_source/get_company_data_source.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/data/mapper/get_company_mapper.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/domain/model/get_company_model.dart';

import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../request/get_company_request.dart';

abstract class GetCompanyRepository {
  Future<Either<Failure, GetCompanyModel>> getCompany(
      GetCompanyRequest request,
      );
}

class GetCompanyRepositoryImplement implements GetCompanyRepository {
  GetCompanyDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  GetCompanyRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, GetCompanyModel>> getCompany(GetCompanyRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.getCompany(request);
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
