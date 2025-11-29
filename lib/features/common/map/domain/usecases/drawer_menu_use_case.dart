// drawer_menu_use_case.dart
import 'package:dartz/dartz.dart';

import '../../../../../core/error_handler/failure.dart';
import '../../../../../core/usecase/base_usecase.dart';
import '../../data/repository/drawer_menu_repository.dart';
import '../models/drawer_menu_model.dart';

class DrawerMenuUseCase implements BaseGetUseCase<DrawerMenuModel> {
  final DrawerMenuRepository _repository;

  DrawerMenuUseCase(this._repository);

  @override
  Future<Either<Failure, DrawerMenuModel>> execute() async {
    return await _repository.getDrawerMenu();
  }
}
