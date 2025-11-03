import 'package:app_mobile/features/providers/offer_provider_new/common/data/data_source/get_my_company_data_source.dart';
import 'package:app_mobile/features/providers/offer_provider_new/common/data/mapper/get_my_company_mapper.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../../domain/models/get_my_company_model.dart';

abstract class GetMyCompanyRepository {
  Future<Either<Failure, GetMyCompanyModel>> getMyCompany();
}

class GetMyCompanyRepositoryImplement implements GetMyCompanyRepository {
  GetMyCompanyDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  GetMyCompanyRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, GetMyCompanyModel>> getMyCompany() async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.getMyCompany();
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
