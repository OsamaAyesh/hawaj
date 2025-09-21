import 'package:app_mobile/features/providers/offers_provider/details_my_company/data/request/get_my_company_details_request.dart';
import 'package:app_mobile/features/providers/offers_provider/details_my_company/domain/models/get_my_company_details_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/get_my_company_details_repository.dart';

class GetMyCompanyDetailsUseCase
    implements
        BaseUseCase<GetMyCompanyDetailsRequest, GetMyCompanyDetailsModel> {
  final GetMyCompanyDetailsRepository _repository;

  GetMyCompanyDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, GetMyCompanyDetailsModel>> execute(
      GetMyCompanyDetailsRequest request) async {
    return await _repository.getMyCompanyDetails(
      request,
    );
  }
}
