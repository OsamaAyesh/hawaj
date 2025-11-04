import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/users/real_estate_user/data/repository/add_visit_repository.dart';
import 'package:app_mobile/features/users/real_estate_user/data/repository/get_real_estate_user_repository.dart';
import 'package:app_mobile/features/users/real_estate_user/data/request/add_visit_request.dart';
import 'package:app_mobile/features/users/real_estate_user/data/request/get_real_estate_user_request.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../models/get_real_estate_user_model.dart';

class AddVisitUseCase
    implements BaseUseCase<AddMyVisitRequest, WithOutDataModel> {
  final AddVisitRepository _repository;

  AddVisitUseCase(this._repository);

  @override
  Future<Either<Failure, WithOutDataModel>> execute(
      AddMyVisitRequest request) async {
    return await _repository.addMyVisit(request);
  }
}
