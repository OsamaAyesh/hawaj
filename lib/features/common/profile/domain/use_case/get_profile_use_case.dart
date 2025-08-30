

import 'package:app_mobile/features/common/profile/data/repository/get_profile_repository.dart';
import 'package:app_mobile/features/common/profile/domain/model/get_profile_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error_handler/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';


class GetProfileUseCase implements BaseGetUseCase<GetProfileModel> {
  final GetProfileRepository _repository;

  GetProfileUseCase(this._repository);

  @override
  Future<Either<Failure, GetProfileModel>> execute() async {
    return await _repository.getProfile(
    );
  }
}
