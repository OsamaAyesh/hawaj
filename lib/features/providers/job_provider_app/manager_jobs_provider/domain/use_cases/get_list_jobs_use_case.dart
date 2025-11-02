import 'package:app_mobile/features/providers/job_provider_app/manager_jobs_provider/data/repository/get_list_jobs_repository.dart';
import 'package:app_mobile/features/providers/job_provider_app/manager_jobs_provider/domain/models/get_list_jobs_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';

class GetListJobsUseCase implements BaseGetUseCase<GetListJobsModel> {
  final GetListJobsRepository _repository;

  GetListJobsUseCase(this._repository);

  @override
  Future<Either<Failure, GetListJobsModel>> execute() async {
    return await _repository.getListJobs();
  }
}
