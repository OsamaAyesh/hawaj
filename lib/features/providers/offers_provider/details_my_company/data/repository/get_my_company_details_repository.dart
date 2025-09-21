import 'package:app_mobile/features/providers/offers_provider/details_my_company/data/data_source/get_my_company_details_data_source.dart';
import 'package:app_mobile/features/providers/offers_provider/details_my_company/data/mapper/get_my_company_details_mapper.dart';
import 'package:app_mobile/features/providers/offers_provider/details_my_company/data/request/get_my_company_details_request.dart';
import 'package:app_mobile/features/providers/offers_provider/details_my_company/domain/models/get_my_company_details_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';

abstract class GetMyCompanyDetailsRepository {
  Future<Either<Failure, GetMyCompanyDetailsModel>> getMyCompanyDetails(
    GetMyCompanyDetailsRequest request,
  );
}

class GetMyCompanyDetailsRepositoryImplement
    implements GetMyCompanyDetailsRepository {
  GetMyCompanyDetailsDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  GetMyCompanyDetailsRepositoryImplement(
      this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, GetMyCompanyDetailsModel>> getMyCompanyDetails(
      GetMyCompanyDetailsRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.getMyCompanyDetails(request);
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
