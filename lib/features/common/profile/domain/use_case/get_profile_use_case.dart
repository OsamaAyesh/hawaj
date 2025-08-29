

import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/common/auth/data/repository/send_otp_repository.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/domain/model/send_otp_model.dart';
import 'package:app_mobile/features/common/profile/data/repository/get_profile_repository.dart';
import 'package:app_mobile/features/common/profile/data/repository/update_avatar_repository.dart';
import 'package:app_mobile/features/common/profile/data/repository/update_profile_repository.dart';
import 'package:app_mobile/features/common/profile/data/request/update_avatar_request.dart';
import 'package:app_mobile/features/common/profile/data/request/update_profile_request.dart';
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
