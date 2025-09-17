import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/get_my_company_set_offer_repository.dart';
import '../../data/request/get_my_company_set_offer_request.dart';
import '../model/get_my_company_set_offer_model.dart';

class GetMyCompanySetOfferUseCase
    implements
        BaseUseCase<GetMyOrganizationSetOfferRequest,
            GetMyCompanySetOfferModel> {
  final GetMyCompanySetOfferRepository _repository;

  GetMyCompanySetOfferUseCase(this._repository);

  @override
  Future<Either<Failure, GetMyCompanySetOfferModel>> execute(
      GetMyOrganizationSetOfferRequest request) async {
    return await _repository.getMyCompanySetOffer(
      request,
    );
  }
}
