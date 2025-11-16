import 'package:app_mobile/core/error_handler/failure.dart' show Failure;
import 'package:dartz/dartz.dart';

import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/get_offer_plans_repository.dart';
import '../../data/request/get_offer_provider_plans_request.dart';
import '../models/get_offer_plans_model.dart';

class GetOfferPlansUseCase
    implements BaseUseCase<GetOfferProviderPlansRequest, GetOfferPlansModel> {
  final GetOfferPlansRepository _repository;

  GetOfferPlansUseCase(this._repository);

  @override
  Future<Either<Failure, GetOfferPlansModel>> execute(
      GetOfferProviderPlansRequest request) async {
    return await _repository.getOfferProviderPlans(
      request,
    );
  }
}
