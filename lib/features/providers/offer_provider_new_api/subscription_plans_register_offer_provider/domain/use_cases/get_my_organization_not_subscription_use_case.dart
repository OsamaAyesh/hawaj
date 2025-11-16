import 'package:app_mobile/core/error_handler/failure.dart' show Failure;
import 'package:app_mobile/core/model/get_my_organization_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/get_my_organization_not_subscription_repository.dart';
import '../../data/request/get_offer_provider_plans_request.dart';

class GetMyOrganizationNotSubscriptionUseCase
    implements
        BaseUseCase<GetOfferProviderPlansRequest, GetMyOrganizationModel> {
  final GetMyOrganizationNotSubscriptionRepository _repository;

  GetMyOrganizationNotSubscriptionUseCase(this._repository);

  @override
  Future<Either<Failure, GetMyOrganizationModel>> execute(
      GetOfferProviderPlansRequest request) async {
    return await _repository.getMyOrganizationsNew(
      request,
    );
  }
}
