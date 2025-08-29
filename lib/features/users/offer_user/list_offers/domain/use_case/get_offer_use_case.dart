import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/common/auth/data/repository/send_otp_repository.dart';
import 'package:app_mobile/features/common/auth/data/repository/verfiy_otp_repository.dart';
import 'package:app_mobile/features/common/auth/data/request/send_otp_request.dart';
import 'package:app_mobile/features/common/auth/data/request/verfiy_otp_request.dart';
import 'package:app_mobile/features/common/auth/domain/model/send_otp_model.dart';
import 'package:app_mobile/features/common/auth/domain/model/verfiy_otp_model.dart';
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/data/repository/get_my_offer_repository.dart';
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/domain/model/offer_model.dart';
import 'package:app_mobile/features/providers/offers_provider/register_company_offer_provider/data/repository/register_my_company_offer_provider_repository.dart';
import 'package:app_mobile/features/providers/offers_provider/register_company_offer_provider/data/request/register_my_company_offer_provider_request.dart';
import 'package:app_mobile/features/users/offer_user/list_offers/data/repository/get_offers_user_repository.dart';
import 'package:app_mobile/features/users/offer_user/list_offers/domain/model/offer_user_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';

class GetOfferUseCase implements BaseGetUseCase<OfferUserModel> {
  final GetOffersUserRepository _repository;

  GetOfferUseCase(this._repository);

  @override
  Future<Either<Failure, OfferUserModel>> execute() async {
    return await _repository.getOffersData();
  }
}
