import 'package:app_mobile/core/mapper/with_out_data_mapper.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/data/data_source/edit_profile_real_estate_owner_data_source.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/error_handler.dart';
import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/internet_checker/interent_checker.dart';
import '../request/edit_profile_my_property_owner_request.dart';

abstract class EditProfileRealEstateOwnerRepository {
  Future<Either<Failure, WithOutDataModel>> editProfileMyPropertyOwner(
    EditProfileMyPropertyOwnerRequest request,
  );
}

class EditProfileRealEstateOwnerRepositoryImplement
    implements EditProfileRealEstateOwnerRepository {
  EditProfileRealEstateOwnerDataSource remoteDataSource;
  NetworkInfo _networkInfo;

  EditProfileRealEstateOwnerRepositoryImplement(
      this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, WithOutDataModel>> editProfileMyPropertyOwner(
      EditProfileMyPropertyOwnerRequest request) async {
    // if (await _networkInfo.isConnected) {
    /// Its connected
    try {
      final response =
          await remoteDataSource.editProfileMyPropertyOwner(request);
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
