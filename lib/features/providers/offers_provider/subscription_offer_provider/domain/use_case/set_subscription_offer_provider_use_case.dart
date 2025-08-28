import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/common/auth/data/repository/send_otp_repository.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/domain/model/send_otp_model.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/repository/set_subscription_offer_provider_repository.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/request/set_subscription_offer_provider_request.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/domain/model/plan_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/get_plan_repository.dart';



class SetSubscriptionOfferProviderUseCase implements BaseUseCase<SetSubscriptionOfferProviderRequest,WithOutDataModel> {
  final SetSubscriptionOfferProviderRepository _repository;

  SetSubscriptionOfferProviderUseCase(this._repository);

  @override
  Future<Either<Failure, WithOutDataModel>> execute(SetSubscriptionOfferProviderRequest request) async {
    return await _repository.setSubscriptionOfferProvider(
      request

    );
  }
}
