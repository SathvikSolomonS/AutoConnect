import 'package:flutter/material.dart';
import '../../models/car_model.dart';

class CompareScreen extends StatelessWidget {
  final List<CarModel> cars;
  const CompareScreen({super.key, required this.cars});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compare Cars')),
      body: ListView(
        children: [
          _row('Price', cars.map((c) => c.basePrice).toList()),
          _row('Fuel', cars.map((c) => c.fuel).toList()),
          _row('Transmission', cars.map((c) => c.transmission).toList()),
        ],
      ),
    );
  }

  Widget _row(String label, List values) {
    return Card(
      child: ListTile(
        title: Text(label),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: values.map((v) => Text(v.toString())).toList(),
        ),
      ),
    );
  }
}
