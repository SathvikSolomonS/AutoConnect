import 'car_service.dart';
import '../data/dummy_cars.dart';
import '../models/car_model.dart';

class CarRepository {
  final CarService _service = CarService();

  Stream<List<CarModel>> getAllCars() {
    return _service.getCars().map((remoteCars) {
      final ids = remoteCars.map((e) => e.id).toSet();

      final merged = [
        ...dummyCars.where((c) => !ids.contains(c.id)),
        ...remoteCars,
      ];

      return merged;
    });
  }
}
