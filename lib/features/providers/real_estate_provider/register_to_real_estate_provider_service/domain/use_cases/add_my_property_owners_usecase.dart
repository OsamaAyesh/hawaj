// domain/usecase/add_my_property_owners_usecase.dart
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/add_my_property_owners_repository.dart';
import '../../data/request/add_my_property_owners_request.dart';

class AddMyPropertyOwnersUseCase
    implements BaseUseCase<AddMyPropertyOwnersRequest, WithOutDataModel> {
  final AddMyPropertyOwnersRepository _repository;

  AddMyPropertyOwnersUseCase(this._repository);

  @override
  Future<Either<Failure, WithOutDataModel>> execute(
      AddMyPropertyOwnersRequest request) async {
    return await _repository.addMyPropertyOwners(request);
  }
}
