import 'package:app_mobile/features/common/lists/data/data_source/get_lists_data_source.dart';
import 'package:app_mobile/features/common/lists/data/mapper/get_lists_mapper.dart';
import 'package:app_mobile/features/common/lists/data/request/get_lists_request.dart';
import 'package:app_mobile/features/common/lists/domain/models/get_lists_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error_handler/error_handler.dart';
import '../../../../../core/error_handler/failure.dart';
import '../../../../../core/internet_checker/interent_checker.dart';

abstract class GetListsRepository {
  Future<Either<Failure, GetListsModel>> getLists(
    GetListsRequest request,
  );
}

class GetListsRepositoryImplement implements GetListsRepository {
  GetListsDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  GetListsRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, GetListsModel>> getLists(
      GetListsRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response = await remoteDataSource.getLists(request);
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
