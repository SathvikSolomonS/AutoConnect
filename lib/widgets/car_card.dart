import 'package:flutter/material.dart';
import '../models/car_model.dart';

class CarCard extends StatelessWidget {
  final CarModel car;
  const CarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(
          car.images.first,
          width: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.car_rental),
        ),
        title: Text(car.name),
        subtitle: Text(
          '₹ ${(car.basePrice / 100000).toStringAsFixed(1)} L',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, size: 16, color: Colors.green),
            Text(car.rating.toString()),
          ],
        ),
      ),
    );
  }
}
