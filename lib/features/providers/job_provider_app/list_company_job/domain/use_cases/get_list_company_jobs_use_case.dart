import 'package:app_mobile/features/providers/job_provider_app/list_company_job/data/repository/get_list_company_jobs_repository.dart';
import 'package:app_mobile/features/providers/job_provider_app/list_company_job/domain/models/get_list_company_jobs_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';

class GetListCompanyJobsUseCase
    implements BaseGetUseCase<GetListCompanyJobsModel> {
  final GetListCompanyJobsRepository _repository;

  GetListCompanyJobsUseCase(this._repository);

  @override
  Future<Either<Failure, GetListCompanyJobsModel>> execute() async {
    return await _repository.getListCompanyJobs();
  }
}
