// drawer_menu_repository.dart
import 'package:dartz/dartz.dart';

import '../../../../../core/error_handler/error_handler.dart';
import '../../../../../core/error_handler/failure.dart';
import '../../../../../core/internet_checker/interent_checker.dart';
import '../../domain/models/drawer_menu_model.dart';
import '../data_sourcce/drawer_menu_data_source.dart';
import '../mapper/drawer_menu_mapper.dart';

abstract class DrawerMenuRepository {
  Future<Either<Failure, DrawerMenuModel>> getDrawerMenu();
}

class DrawerMenuRepositoryImplement implements DrawerMenuRepository {
  final DrawerMenuDataSource remoteDataSource;
  final NetworkInfo _networkInfo;

  DrawerMenuRepositoryImplement(this._networkInfo, this.remoteDataSource);

  @override
  Future<Either<Failure, DrawerMenuModel>> getDrawerMenu() async {
    try {
      final response = await remoteDataSource.getDrawerMenu();
      return Right(response.toDomain());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
