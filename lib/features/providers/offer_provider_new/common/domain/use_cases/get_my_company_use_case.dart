import 'package:app_mobile/features/providers/offer_provider_new/common/data/repository/get_my_company_repository.dart';
import 'package:app_mobile/features/providers/offer_provider_new/common/domain/models/get_my_company_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';

class GetMyCompanyUseCase implements BaseGetUseCase<GetMyCompanyModel> {
  final GetMyCompanyRepository _repository;

  GetMyCompanyUseCase(this._repository);

  @override
  Future<Either<Failure, GetMyCompanyModel>> execute() async {
    return await _repository.getMyCompany();
  }
}
