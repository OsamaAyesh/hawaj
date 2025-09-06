import 'package:app_mobile/features/common/auth/data/repository/send_otp_repository.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/domain/model/send_otp_model.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/data/repository/get_my_organization_offer_provider_repository.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/domain/model/get_my_organization_offer_provider_model.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/domain/model/plan_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/get_plan_repository.dart';



class GetMyOrganizationOfferProviderUseCase implements BaseGetUseCase<GetMyOrganizationOfferProviderModel> {
  final GetMyOrganizationOfferProviderRepository _repository;

  GetMyOrganizationOfferProviderUseCase(this._repository);

  @override
  Future<Either<Failure, GetMyOrganizationOfferProviderModel>> execute() async {
    return await _repository.getMyOrganizations(

    );
  }
}
