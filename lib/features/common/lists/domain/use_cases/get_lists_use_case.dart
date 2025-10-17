import 'package:app_mobile/features/common/lists/data/repository/get_lists_repository.dart';
import 'package:app_mobile/features/common/lists/data/request/get_lists_request.dart';
import 'package:app_mobile/features/common/lists/domain/models/get_lists_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error_handler/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';

class GetListsUseCase implements BaseUseCase<GetListsRequest, GetListsModel> {
  final GetListsRepository _repository;

  GetListsUseCase(this._repository);

  @override
  Future<Either<Failure, GetListsModel>> execute(
      GetListsRequest request) async {
    return await _repository.getLists(request);
  }
}
