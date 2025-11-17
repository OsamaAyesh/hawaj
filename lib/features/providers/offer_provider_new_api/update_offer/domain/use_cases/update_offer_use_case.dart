// update_offer_use_case.dart
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/update_offer_repository.dart';
import '../../data/request/update_offer_request.dart';

class UpdateOfferUseCase
    implements BaseUseCase<UpdateOfferRequest, WithOutDataModel> {
  final UpdateOfferRepository _repository;

  UpdateOfferUseCase(this._repository);

  @override
  Future<Either<Failure, WithOutDataModel>> execute(
      UpdateOfferRequest request) async {
    return await _repository.updateOfferRequest(request);
  }
}
