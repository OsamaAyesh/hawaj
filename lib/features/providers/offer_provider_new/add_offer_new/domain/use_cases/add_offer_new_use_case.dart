import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/providers/offer_provider_new/add_offer_new/data/repository/add_offer_new_repository.dart';
import 'package:app_mobile/features/providers/offer_provider_new/add_offer_new/data/request/add_offer_new_request.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';

class AddOfferNewUseCase
    implements BaseUseCase<AddOfferNewRequest, WithOutDataModel> {
  final AddOfferNewRepository _repository;

  AddOfferNewUseCase(this._repository);

  @override
  Future<Either<Failure, WithOutDataModel>> execute(
      AddOfferNewRequest request) async {
    return await _repository.addOfferNewRequest(
      request,
    );
  }
}
