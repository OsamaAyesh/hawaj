import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/repository/delete_my_real_estate_repository.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/request/delete_my_real_estate_request.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';

class DeleteMyRealEstateUseCase
    implements BaseUseCase<DeleteMyRealEstateRequest, WithOutDataModel> {
  final DeleteMyRealEstateRepository _repository;

  DeleteMyRealEstateUseCase(this._repository);

  @override
  Future<Either<Failure, WithOutDataModel>> execute(
      DeleteMyRealEstateRequest request) async {
    return await _repository.deleteMyRealEstate(request);
  }
}
