// data/repository/add_my_property_owners_repository.dart
import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/error_handler/response_code.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../../../../../../core/resources/manager_strings.dart';
import '../data_source/add_my_property_owners_data_source.dart';
import '../request/add_my_property_owners_request.dart';

abstract class AddMyPropertyOwnersRepository {
  Future<Either<Failure, WithOutDataModel>> addMyPropertyOwners(
    AddMyPropertyOwnersRequest request,
  );
}

class AddMyPropertyOwnersRepositoryImplement
    implements AddMyPropertyOwnersRepository {
  AddMyPropertyOwnersDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  AddMyPropertyOwnersRepositoryImplement(
      this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, WithOutDataModel>> addMyPropertyOwners(
      AddMyPropertyOwnersRequest request) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.addMyPropertyOwners(request);
        return Right(response.toDomain());
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(
        Failure(
          ResponseCode.noInternetConnection,
          ManagerStrings.noInternetConnection,
        ),
      );
    }
  }
}
