import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/providers/real_estate_provider/add_real_estate/data/repository/add_real_estate_repository.dart';
import 'package:app_mobile/features/providers/real_estate_provider/add_real_estate/data/request/add_real_state_request.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';

class AddRealEstateUseCase
    implements BaseUseCase<AddRealStateRequest, WithOutDataModel> {
  final AddRealEstateRepository _repository;

  AddRealEstateUseCase(this._repository);

  @override
  Future<Either<Failure, WithOutDataModel>> execute(
      AddRealStateRequest request) async {
    return await _repository.addRalEstate(request);
  }
}
