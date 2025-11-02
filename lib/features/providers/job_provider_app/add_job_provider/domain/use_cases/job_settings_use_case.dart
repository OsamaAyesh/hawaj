import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/job_settings_repository.dart';
import '../models/get_settings_base_model.dart';

class JobSettingsUseCase implements BaseGetUseCase<GetSettingsBaseModel> {
  final JobSettingsRepository _repository;

  JobSettingsUseCase(this._repository);

  @override
  Future<Either<Failure, GetSettingsBaseModel>> execute() async {
    return await _repository.getJobsSettings();
  }
}
