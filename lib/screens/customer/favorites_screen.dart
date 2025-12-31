import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/dummy_cars.dart';
import '../../widgets/car_grid_card.dart';
import 'car_detail_screen.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  Set<String> favIds = {};

  @override
  void initState() {
    super.initState();
    _loadFavs();
  }

  Future<void> _loadFavs() async {
    final prefs = await SharedPreferences.getInstance();
    favIds = prefs.getStringList('favourites')?.toSet() ?? {};
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final favCars =
    dummyCars.where((c) => favIds.contains(c.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: favCars.isEmpty
          ? const Center(child: Text('No favourites yet'))
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: favCars.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemBuilder: (_, i) {
          final car = favCars[i];
          return CarGridCard(
            car: car,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CarDetailScreen(car: car),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
