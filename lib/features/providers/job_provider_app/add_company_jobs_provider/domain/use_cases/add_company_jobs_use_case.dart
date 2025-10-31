import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_company_jobs_provider/data/request/add_company_jobs_request.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/add_company_jobs_repository.dart';

class AddCompanyJobsUseCase
    implements BaseUseCase<AddCompanyJobsRequest, WithOutDataModel> {
  final AddCompanyJobsRepository _repository;

  AddCompanyJobsUseCase(this._repository);

  @override
  Future<Either<Failure, WithOutDataModel>> execute(
      AddCompanyJobsRequest request) async {
    return await _repository.addCompany(request);
  }
}
