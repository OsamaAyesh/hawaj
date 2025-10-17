import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/providers/real_estate_provider/add_real_estate/data/data_source/add_real_estate_data_source.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../request/add_real_state_request.dart';

abstract class AddRealEstateRepository {
  Future<Either<Failure, WithOutDataModel>> addRalEstate(
    AddRealStateRequest request,
  );
}

class AddRealEstateRepositoryImplement implements AddRealEstateRepository {
  AddRealEstateDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  AddRealEstateRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, WithOutDataModel>> addRalEstate(
      AddRealStateRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.addRalEstate(request);
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
