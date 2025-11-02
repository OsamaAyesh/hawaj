import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/get_job_applications_repository.dart';
import '../../data/request/get_job_applications_request.dart';
import '../models/get_job_applications_model.dart';

class GetJobApplicationsUseCase
    implements BaseUseCase<GetJobApplicationRequest, GetJobApplicationsModel> {
  final GetJobApplicationsRepository _repository;

  GetJobApplicationsUseCase(this._repository);

  @override
  Future<Either<Failure, GetJobApplicationsModel>> execute(
      GetJobApplicationRequest request) async {
    return await _repository.getJobApplications(request);
  }
}
