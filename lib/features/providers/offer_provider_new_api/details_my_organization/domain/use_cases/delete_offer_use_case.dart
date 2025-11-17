// delete_offer_use_case.dart
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/error_handler/failure.dart';
import '../../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/delete_offer_repository.dart';
import '../../data/request/delete_my_offer_request.dart';

class DeleteOfferUseCase
    implements BaseUseCase<DeleteOfferRequest, WithOutDataModel> {
  final DeleteOfferRepository _repository;

  DeleteOfferUseCase(this._repository);

  @override
  Future<Either<Failure, WithOutDataModel>> execute(
      DeleteOfferRequest request) async {
    return await _repository.deleteMyOfferRequest(request);
  }
}
