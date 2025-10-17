import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/data/repository/get_property_owners_repository.dart';
import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/data/request/get_property_owners_request.dart';
import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/domain/models/get_property_owners_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';

class GetPropertyOwnersUseCases
    implements BaseUseCase<GetPropertyOwnersRequest, GetPropertyOwnersModel> {
  final GetPropertyOwnersRepository _repository;

  GetPropertyOwnersUseCases(this._repository);

  @override
  Future<Either<Failure, GetPropertyOwnersModel>> execute(
      GetPropertyOwnersRequest request) async {
    return await _repository.getMyPropertyOwners(request);
  }
}
