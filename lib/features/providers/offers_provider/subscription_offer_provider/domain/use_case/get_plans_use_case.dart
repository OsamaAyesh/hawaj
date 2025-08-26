import 'package:app_mobile/features/common/auth/data/repository/send_otp_repository.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/domain/model/send_otp_model.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/domain/model/plan_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/get_plan_repository.dart';



class GetPlansUseCase implements BaseGetUseCase<PlanModel> {
  final GetPlanRepository _repository;

  GetPlansUseCase(this._repository);

  @override
  Future<Either<Failure, PlanModel>> execute() async {
    return await _repository.getPlansOfferProvider(

    );
  }
}
