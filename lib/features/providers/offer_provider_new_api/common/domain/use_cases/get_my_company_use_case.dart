import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/get_my_company_repository.dart';
import '../models/get_my_company_model.dart';

class GetMyCompanyUseCase implements BaseGetUseCase<GetMyCompanyModel> {
  final GetMyCompanyRepository _repository;

  GetMyCompanyUseCase(this._repository);

  @override
  Future<Either<Failure, GetMyCompanyModel>> execute() async {
    return await _repository.getMyCompany();
  }
}
