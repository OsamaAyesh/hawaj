import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/get_organization_types_repository.dart';
import '../../data/request/get_organization_types_request.dart';
import '../models/get_organization_types_model.dart';

class GetOrganizationTypesUseCase
    implements
        BaseUseCase<GetOrganizationTypesRequest, GetOrganizationTypesModel> {
  final GetOrganizationTypesRepository _repository;

  GetOrganizationTypesUseCase(this._repository);

  @override
  Future<Either<Failure, GetOrganizationTypesModel>> execute(
      GetOrganizationTypesRequest request) async {
    return await _repository.getOrganizationTypes(
      request,
    );
  }
}
