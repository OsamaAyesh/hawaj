import 'package:app_mobile/features/splash_and_boarding/data/repository/get_on_boarding_data_repository.dart';
import 'package:app_mobile/features/splash_and_boarding/domain/model/on_boarding_model.dart';

import '../../../../../core/error_handler/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class OnBoardingUseCase implements BaseGetUseCase<OnBoardingModel> {
  final GetOnBoardingDataRepository _repository;

  OnBoardingUseCase(this._repository);

  @override
  Future<Either<Failure, OnBoardingModel>> execute() async {
    return await _repository.getOnBoardingData();
  }
}
