import '../../data/data_sourcce/location_service.dart';
import '../entities/location_entity.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/repositories/location_repository.dart';

abstract class LocationRepository {
  Future<LocationEntity> getCurrentLocation();
}

class LocationRepositoryImpl implements LocationRepository {
  final LocationService service;

  LocationRepositoryImpl(this.service);

  @override
  Future<LocationEntity> getCurrentLocation() async {
    final position = await service.getCurrentPosition();
    return LocationEntity(latitude: position.latitude, longitude: position.longitude);
  }
}
