import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/common/auth/data/repository/send_otp_repository.dart';
import 'package:app_mobile/features/common/auth/data/repository/verfiy_otp_repository.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/data/request/verfiy_otp_request.dart';
import 'package:app_mobile/features/common/auth/domain/model/send_otp_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error_handler/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';

class VerfiyUseCase implements BaseUseCase<VerfiyOtpRequest, WithOutDataModel> {
  final VerfiyOtpRepository _repository;

  VerfiyUseCase(this._repository);

  @override
  Future<Either<Failure, WithOutDataModel>> execute(
      VerfiyOtpRequest request) async {
    return await _repository.verfiyOtp(request);
  }
}
