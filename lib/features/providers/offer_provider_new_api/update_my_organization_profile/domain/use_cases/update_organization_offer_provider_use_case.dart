import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/update_organization_offer_provider_repository.dart';
import '../../data/request/update_organization_offer_provider_request.dart';

class UpdateOrganizationOfferProviderUseCase
    implements
        BaseUseCase<UpdateOrganizationOfferProviderRequest, WithOutDataModel> {
  final UpdateOrganizationOfferProviderRepository _repository;

  UpdateOrganizationOfferProviderUseCase(this._repository);

  @override
  Future<Either<Failure, WithOutDataModel>> execute(
      UpdateOrganizationOfferProviderRequest request) async {
    return await _repository.updateOrganizationOfferProvider(
      request,
    );
  }
}
