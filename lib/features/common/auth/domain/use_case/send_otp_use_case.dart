import 'package:app_mobile/features/common/auth/data/repository/send_otp_repository.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/domain/model/send_otp_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error_handler/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';


class SendOtpUseCase implements BaseUseCase<SendOtpRequest,SendOtpModel> {
  final SendOtpRepository _repository;

  SendOtpUseCase(this._repository);

  @override
  Future<Either<Failure, SendOtpModel>> execute(SendOtpRequest request) async {
    return await _repository.sendOtp(
        request
    );
  }
}
