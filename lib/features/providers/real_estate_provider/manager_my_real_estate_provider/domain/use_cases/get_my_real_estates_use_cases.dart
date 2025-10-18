import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/repository/get_my_real_estates_repository.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/data/request/get_my_real_estates_request.dart';
import 'package:app_mobile/features/providers/real_estate_provider/manager_my_real_estate_provider/domain/models/get_my_real_estates_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';

class GetMyRealEstatesUseCases
    implements BaseUseCase<GetMyRealEstatesRequest, GetMyRealEstatesModel> {
  final GetMyRealEstatesRepository _repository;

  GetMyRealEstatesUseCases(this._repository);

  @override
  Future<Either<Failure, GetMyRealEstatesModel>> execute(
      GetMyRealEstatesRequest request) async {
    return await _repository.getMyRealEstate(request);
  }
}
