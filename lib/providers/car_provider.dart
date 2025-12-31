import 'package:flutter/material.dart';
import '../services/car_service.dart';
import '../models/car_model.dart';

class CarProvider extends ChangeNotifier {
  final _service = CarService();

  Stream<List<CarModel>> get cars => _service.getCars();
}
