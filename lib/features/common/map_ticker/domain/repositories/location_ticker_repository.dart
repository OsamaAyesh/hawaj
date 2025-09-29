import '../../data/data_sourcce/location_ticker_service.dart';
import '../entities/location_ticker_entity.dart';

abstract class LocationTickerRepository {
  Future<LocationTickerEntity> getCurrentLocation();
}

class LocationTickerRepositoryImpl implements LocationTickerRepository {
  final LocationTickerService service;

  LocationTickerRepositoryImpl(this.service);

  @override
  Future<LocationTickerEntity> getCurrentLocation() async {
    final position = await service.getCurrentPosition();
    return LocationTickerEntity(
        latitude: position.latitude, longitude: position.longitude);
  }
}
