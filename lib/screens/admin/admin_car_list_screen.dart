import 'package:flutter/material.dart';

import '../../models/car_model.dart';
import '../../services/car_service.dart';
import 'add_edit_car_screen.dart'; // ✅ REQUIRED IMPORT

class AdminCarListScreen extends StatelessWidget {
  const AdminCarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = CarService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Cars'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddEditCarScreen(), // ✅ WORKS
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<CarModel>>(
        stream: service.getCars(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final cars = snapshot.data!;

          if (cars.isEmpty) {
            return const Center(child: Text('No cars added yet'));
          }

          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (_, i) {
              final car = cars[i];
              return ListTile(
                title: Text(car.name),
                subtitle: Text('₹ ${car.basePrice}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AddEditCarScreen(car: car), // ✅
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          service.deleteCar(car.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
