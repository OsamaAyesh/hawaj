import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_job_provider/data/repository/add_job_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/request/add_job_request.dart';

class AddJobUseCase implements BaseUseCase<AddJobRequest, WithOutDataModel> {
  final AddJobRepository _repository;

  AddJobUseCase(this._repository);

  @override
  Future<Either<Failure, WithOutDataModel>> execute(
      AddJobRequest request) async {
    return await _repository.addJobRequest(request);
  }
}
