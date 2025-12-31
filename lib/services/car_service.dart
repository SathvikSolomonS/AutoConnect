import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car_model.dart';

class CarService {
  final _cars = FirebaseFirestore.instance.collection('cars');

  Stream<List<CarModel>> getCars() {
    return _cars.snapshots().map(
          (snap) => snap.docs
          .map((doc) => CarModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Future<void> addCar(CarModel car) async {
    await _cars.add(car.toMap());
  }

  Future<void> updateCar(CarModel car) async {
    await _cars.doc(car.id).update(car.toMap());
  }

  Future<void> deleteCar(String id) async {
    await _cars.doc(id).delete();
  }
}
