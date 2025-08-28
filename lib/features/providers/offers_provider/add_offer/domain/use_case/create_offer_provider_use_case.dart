import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/common/auth/data/repository/send_otp_repository.dart';
import 'package:app_mobile/features/common/auth/data/repository/verfiy_otp_repository.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/data/request/verfiy_otp_request.dart';
import 'package:app_mobile/features/common/auth/domain/model/send_otp_model.dart';
import 'package:app_mobile/features/common/auth/domain/model/verfiy_otp_model.dart';
import 'package:app_mobile/features/providers/offers_provider/add_offer/data/repository/create_offer_provider_repository.dart';
import 'package:app_mobile/features/providers/offers_provider/add_offer/data/request/create_offer_provider_request.dart';
import 'package:app_mobile/features/providers/offers_provider/register_company_offer_provider/data/repository/register_my_company_offer_provider_repository.dart';
import 'package:app_mobile/features/providers/offers_provider/register_company_offer_provider/data/request/register_my_company_offer_provider_request.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';

class CreateOfferProviderUseCase implements
        BaseUseCase<CreateOfferProviderRequest, WithOutDataModel> {
  final CreateOfferProviderRepository _repository;

  CreateOfferProviderUseCase(this._repository);

  @override
  Future<Either<Failure, WithOutDataModel>> execute(
      CreateOfferProviderRequest request) async {
    return await _repository.createOfferProvider(
      request,
    );
  }
}
