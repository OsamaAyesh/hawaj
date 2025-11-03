import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/users/jobs_user_app/add_cv_user/data/repository/add_cv_repository.dart';
import 'package:app_mobile/features/users/jobs_user_app/add_cv_user/data/request/add_cv_request.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';

class AddCvUseCase implements BaseUseCase<AddCvRequest, WithOutDataModel> {
  final AddCvRepository _repository;

  AddCvUseCase(this._repository);

  @override
  Future<Either<Failure, WithOutDataModel>> execute(
      AddCvRequest request) async {
    return await _repository.addCvRequest(request);
  }
}
