import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error_handler/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/update_avatar_repository.dart';
import '../../data/request/update_avatar_request.dart';

class UpdateAvatarUseCase
    implements BaseUseCase<UpdateAvatarRequest, WithOutDataModel> {
  final UpdateAvatarRepository _repository;

  UpdateAvatarUseCase(this._repository);

  @override
  Future<Either<Failure, WithOutDataModel>> execute(
    UpdateAvatarRequest request,
  ) async {
    return await _repository.updateAvatar(request);
  }
}
