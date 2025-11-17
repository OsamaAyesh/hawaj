import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/get_my_organization_details_repository.dart';
import '../../data/request/get_my_organization_details_request.dart';
import '../models/get_my_organization_details_model.dart';

class GetMyOrganizationDetailsUseCase
    implements
        BaseUseCase<GetMyOrganizationDetailsRequest,
            GetMyOrganizationDetailsModel> {
  final GetMyOrganizationDetailsRepository _repository;

  GetMyOrganizationDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, GetMyOrganizationDetailsModel>> execute(
      GetMyOrganizationDetailsRequest request) async {
    return await _repository.getMyOrganizationWithId(
      request,
    );
  }
}
