import 'package:dartz/dartz.dart';

import '../../../../../core/error_handler/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/send_data_to_hawaj_repositoy.dart';
import '../../data/request/send_data_request.dart';
import '../models/send_data_model.dart';

class SendDataToHawajUseCase
    implements BaseUseCase<SendDataRequest, SendDataModel> {
  final SendDataToHawajRepositoy _repository;

  SendDataToHawajUseCase(this._repository);

  @override
  Future<Either<Failure, SendDataModel>> execute(
      SendDataRequest request) async {
    return await _repository.sendData(request);
  }
}
