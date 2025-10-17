import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/providers/real_estate_provider/edit_profile_real_state_owner/data/request/edit_profile_my_property_owner_request.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/edit_profile_real_estate_owner_repository.dart';

class EditProfileMyPropertyOwnerUseCase
    implements
        BaseUseCase<EditProfileMyPropertyOwnerRequest, WithOutDataModel> {
  final EditProfileRealEstateOwnerRepository _repository;

  EditProfileMyPropertyOwnerUseCase(this._repository);

  @override
  Future<Either<Failure, WithOutDataModel>> execute(
      EditProfileMyPropertyOwnerRequest request) async {
    return await _repository.editProfileMyPropertyOwner(request);
  }
}
