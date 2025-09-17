import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/repository/get_my_organization_offer_provider_repository.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/domain/model/get_my_organization_offer_provider_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/request/get_organizations_request.dart';

class GetMyOrganizationOfferProviderUseCase
    implements
        BaseUseCase<GetOrganizationsRequest,
            GetMyOrganizationOfferProviderModel> {
  final GetMyOrganizationOfferProviderRepository _repository;

  GetMyOrganizationOfferProviderUseCase(this._repository);

  @override
  Future<Either<Failure, GetMyOrganizationOfferProviderModel>> execute(
      GetOrganizationsRequest request) async {
    return await _repository.getMyOrganizations(request);
  }
}
