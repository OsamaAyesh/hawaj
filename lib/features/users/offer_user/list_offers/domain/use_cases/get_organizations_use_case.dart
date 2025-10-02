import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../../../../../providers/offers_provider/subscription_offer_provider/data/request/get_organizations_request.dart';
import '../../data/repository/get_organizations_repository.dart';
import '../models/get_organizations_model.dart';

class GetOrganizationsUseCase
    implements BaseUseCase<GetOrganizationsRequest, GetOrganizationsModel> {
  final GetOrganizationsRepository _repository;

  GetOrganizationsUseCase(this._repository);

  @override
  Future<Either<Failure, GetOrganizationsModel>> execute(
      GetOrganizationsRequest request) async {
    return await _repository.getOrganizations(
      request,
    );
  }
}
