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
import 'package:app_mobile/features/users/offer_user/company_with_offer/data/repository/get_company_repository.dart';
import 'package:app_mobile/features/users/offer_user/company_with_offer/domain/model/get_company_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/request/get_company_request.dart';

class GetCompanyUseCase
    implements BaseUseCase<GetCompanyRequest, GetCompanyModel> {
  final GetCompanyRepository _repository;

  GetCompanyUseCase(this._repository);

  @override
  Future<Either<Failure, GetCompanyModel>> execute(
      GetCompanyRequest request) async {
    return await _repository.getOrganizationById(
      request,
    );
  }
}
