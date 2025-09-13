import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/common/auth/data/repository/completed_profile_repository.dart';
import 'package:app_mobile/features/common/auth/data/repository/send_otp_repository.dart';
import 'package:app_mobile/features/common/auth/data/request/completed_profile_request.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/domain/model/send_otp_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error_handler/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';


class CompletedProfileUseCase implements BaseUseCase<CompletedProfileRequest,WithOutDataModel> {
  final CompletedProfileRepository _repository;

  CompletedProfileUseCase(this._repository);

  @override
  Future<Either<Failure, WithOutDataModel>> execute(CompletedProfileRequest request) async {
    return await _repository.completedProfile(
        request
    );
  }
}
