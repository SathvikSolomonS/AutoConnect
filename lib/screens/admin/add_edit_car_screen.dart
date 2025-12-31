import 'package:flutter/material.dart';
import '../../models/car_model.dart';
import '../../services/car_service.dart';

class AddEditCarScreen extends StatefulWidget {
  final CarModel? car;
  const AddEditCarScreen({super.key, this.car});

  @override
  State<AddEditCarScreen> createState() => _AddEditCarScreenState();
}

class _AddEditCarScreenState extends State<AddEditCarScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final imageCtrl = TextEditingController();
  final offerCtrl = TextEditingController();

  String fuel = 'Petrol';
  double rating = 4;

  List<String> offers = [];

  @override
  void initState() {
    super.initState();
    if (widget.car != null) {
      nameCtrl.text = widget.car!.name;
      priceCtrl.text = widget.car!.basePrice.toString();
      imageCtrl.text =
      widget.car!.images.isNotEmpty ? widget.car!.images.first : '';
      fuel = widget.car!.fuel;
      rating = widget.car!.rating;
      offers = List<String>.from(widget.car!.offers); // ✅ FIX
    }
  }

  void _addOffer() {
    if (offerCtrl.text.isEmpty) return;
    setState(() {
      offers.add(offerCtrl.text);
      offerCtrl.clear();
    });
  }

  void _removeOffer(int index) {
    setState(() => offers.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add / Edit Car')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Car Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),

              TextFormField(
                controller: priceCtrl,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),

              TextFormField(
                controller: imageCtrl,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),

              DropdownButtonFormField(
                value: fuel,
                items: ['Petrol', 'Diesel', 'Electric']
                    .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                    .toList(),
                onChanged: (v) => fuel = v!,
                decoration: const InputDecoration(labelText: 'Fuel'),
              ),

              const SizedBox(height: 12),

              Text('Rating: ${rating.toStringAsFixed(1)}'),
              Slider(
                value: rating,
                min: 1,
                max: 5,
                divisions: 8,
                onChanged: (v) => setState(() => rating = v),
              ),

              const Divider(height: 32),

              // ---------------- OFFERS ----------------
              const Text(
                'Offers',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: offerCtrl,
                      decoration:
                      const InputDecoration(hintText: 'Enter offer'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addOffer,
                  ),
                ],
              ),

              ...offers.asMap().entries.map(
                    (e) => ListTile(
                  title: Text(e.value),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeOffer(e.key),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                child: const Text('Save Car'),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final car = CarModel(
                    id: widget.car?.id ?? '',
                    brand: 'Admin',
                    name: nameCtrl.text,
                    basePrice: double.parse(priceCtrl.text),
                    fuel: fuel,
                    transmission: 'Manual',
                    rating: rating,
                    images: [
                      imageCtrl.text.isNotEmpty
                          ? imageCtrl.text
                          : 'https://upload.wikimedia.org/wikipedia/commons/7/7e/Car_icon.png'
                    ],
                    specs: {},          // ✅ specs only
                    variants: [],
                    offers: offers,     // ✅ FIXED
                  );

                  final service = CarService();
                  widget.car == null
                      ? await service.addCar(car)
                      : await service.updateCar(car);

                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
