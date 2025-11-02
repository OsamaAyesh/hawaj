import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/providers/job_provider_app/edit_company_job_provider/data/repository/edit_company_jobs_provider_repository.dart';
import 'package:app_mobile/features/providers/job_provider_app/edit_company_job_provider/data/request/edit_company_jobs_provider_request.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';

class EditCompanyJobsProviderUseCase
    implements BaseUseCase<EditCompanyJobsProviderRequest, WithOutDataModel> {
  final EditCompanyJobsProviderRepository _repository;

  EditCompanyJobsProviderUseCase(this._repository);

  @override
  Future<Either<Failure, WithOutDataModel>> execute(
      EditCompanyJobsProviderRequest request) async {
    return await _repository.editCompanyJobsProvider(request);
  }
}
