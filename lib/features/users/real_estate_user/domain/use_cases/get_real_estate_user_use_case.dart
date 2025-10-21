import 'package:app_mobile/features/users/real_estate_user/data/repository/get_real_estate_user_repository.dart';
import 'package:app_mobile/features/users/real_estate_user/data/request/get_real_estate_user_request.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../models/get_real_estate_user_model.dart';

class GetRealEstateUserUseCase
    implements BaseUseCase<GetRealEstateUserRequest, GetRealEstateUserModel> {
  final GetRealEstateUserRepository _repository;

  GetRealEstateUserUseCase(this._repository);

  @override
  Future<Either<Failure, GetRealEstateUserModel>> execute(
      GetRealEstateUserRequest request) async {
    return await _repository.getMyRealUserEstate(request);
  }
}
