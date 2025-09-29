import '../entities/location_ticker_entity.dart';
import '../repositories/location_ticker_repository.dart';

class GetCurrentLocationTickerUsecase {
  final LocationTickerRepository repository;

  GetCurrentLocationTickerUsecase(this.repository);

  Future<LocationTickerEntity> call() async {
    return await repository.getCurrentLocation();
  }
}
