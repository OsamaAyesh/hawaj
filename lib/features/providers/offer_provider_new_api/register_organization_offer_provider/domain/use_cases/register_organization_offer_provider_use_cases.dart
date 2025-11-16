import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/register_organization_offer_provider_repository.dart';
import '../../data/request/register_organization_offer_provider_request.dart';

class RegisterOrganizationOfferProviderUseCases
    implements
        BaseUseCase<RegisterOrganizationOfferProviderRequest,
            WithOutDataModel> {
  final RegisterOrganizationOfferProviderRepository _repository;

  RegisterOrganizationOfferProviderUseCases(this._repository);

  @override
  Future<Either<Failure, WithOutDataModel>> execute(
      RegisterOrganizationOfferProviderRequest request) async {
    return await _repository.registerOrganizationOfferProvider(
      request,
    );
  }
}
