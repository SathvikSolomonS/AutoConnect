import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/dummy_cars.dart';
import '../../models/car_model.dart';
import '../../services/car_service.dart';
import '../../services/search_analytics_service.dart';
import 'car_detail_screen.dart';

enum SortType {
  none,
  priceLowHigh,
  priceHighLow,
  rating,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';
  Set<String> favourites = {};

  Set<String> selectedBrands = {};
  Set<String> selectedFuels = {};
  Set<String> selectedTransmissions = {};
  RangeValues priceRange = const RangeValues(5, 60);
  SortType selectedSort = SortType.none;

  final CarService _carService = CarService();

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    favourites = prefs.getStringList('favourites')?.toSet() ?? {};
    setState(() {});
  }

  Future<void> _toggleFavourite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    favourites.contains(id) ? favourites.remove(id) : favourites.add(id);
    await prefs.setStringList('favourites', favourites.toList());
    setState(() {});
  }

  int get filterCount {
    int count = 0;
    if (selectedBrands.isNotEmpty) count++;
    if (selectedFuels.isNotEmpty) count++;
    if (selectedTransmissions.isNotEmpty) count++;
    if (priceRange.start != 5 || priceRange.end != 60) count++;
    if (selectedSort != SortType.none) count++;
    return count;
  }

  List<CarModel> _applyFilters(List<CarModel> cars) {
    final filtered = cars.where((car) {
      final searchOk =
      car.name.toLowerCase().contains(searchQuery.toLowerCase());

      final brandOk =
          selectedBrands.isEmpty || selectedBrands.contains(car.brand);

      final fuelOk =
          selectedFuels.isEmpty || selectedFuels.contains(car.fuel);

      final transOk = selectedTransmissions.isEmpty ||
          selectedTransmissions.contains(car.transmission);

      final priceLakh = car.basePrice / 100000;
      final priceOk =
          priceLakh >= priceRange.start && priceLakh <= priceRange.end;

      return searchOk && brandOk && fuelOk && transOk && priceOk;
    }).toList();

    switch (selectedSort) {
      case SortType.priceLowHigh:
        filtered.sort((a, b) => a.basePrice.compareTo(b.basePrice));
        break;
      case SortType.priceHighLow:
        filtered.sort((a, b) => b.basePrice.compareTo(a.basePrice));
        break;
      case SortType.rating:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortType.none:
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Cars'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_alt_outlined),
                onPressed: _openFilterSheet,
              ),
              if (filterCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      filterCount.toString(),
                      style: const TextStyle(
                          color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              onChanged: (v) => setState(() => searchQuery = v),
              decoration: InputDecoration(
                hintText: 'Search cars...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),

      body: StreamBuilder<List<CarModel>>(
        stream: _carService.getCars(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allCars = [...dummyCars, ...snapshot.data!];
          final cars = _applyFilters(allCars);

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: cars.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (_, index) {
              final car = cars[index];
              final isFav = favourites.contains(car.id);

              return InkWell(
                onTap: () async {
                  await SearchAnalyticsService.logSearch(car.name);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CarDetailScreen(car: car),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            child: Image.network(
                              car.images.first,
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _placeholder(),
                            ),
                          ),
                          Positioned(
                            right: 6,
                            top: 6,
                            child: IconButton(
                              icon: Icon(
                                isFav
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                isFav ? Colors.red : Colors.white,
                              ),
                              onPressed: () => _toggleFavourite(car.id),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              car.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹ ${(car.basePrice / 100000).toStringAsFixed(1)} L',
                              style: const TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      height: 120,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: const Icon(Icons.directions_car, size: 40),
    );
  }

  // ================= FILTER SHEET =================

  void _openFilterSheet() {
    Set<String> tempBrands = {...selectedBrands};
    Set<String> tempFuels = {...selectedFuels};
    Set<String> tempTransmissions = {...selectedTransmissions};
    SortType tempSort = selectedSort;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter & Sort',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            setSheetState(() {
                              tempBrands.clear();
                              tempFuels.clear();
                              tempTransmissions.clear();
                              tempSort = SortType.none;
                            });

                            setState(() {
                              selectedBrands.clear();
                              selectedFuels.clear();
                              selectedTransmissions.clear();
                              selectedSort = SortType.none;
                            });

                            Navigator.pop(context);
                          },
                          child: const Text('Clear All'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _sectionTitle('Sort By'),
                        _sortRadio('Price: Low to High',
                            SortType.priceLowHigh, tempSort,
                                (v) => setSheetState(() => tempSort = v)),
                        _sortRadio('Price: High to Low',
                            SortType.priceHighLow, tempSort,
                                (v) => setSheetState(() => tempSort = v)),
                        _sortRadio('Rating', SortType.rating, tempSort,
                                (v) => setSheetState(() => tempSort = v)),

                        const Divider(),
                        _sectionTitle('Brand'),
                        ...dummyCars
                            .map((c) => c.brand)
                            .toSet()
                            .map(
                              (b) => CheckboxListTile(
                            title: Text(b),
                            value: tempBrands.contains(b),
                            onChanged: (_) => setSheetState(() {
                              tempBrands.contains(b)
                                  ? tempBrands.remove(b)
                                  : tempBrands.add(b);
                            }),
                          ),
                        ),

                        const Divider(),
                        _sectionTitle('Fuel'),
                        ...dummyCars
                            .map((c) => c.fuel)
                            .toSet()
                            .map(
                              (f) => CheckboxListTile(
                            title: Text(f),
                            value: tempFuels.contains(f),
                            onChanged: (_) => setSheetState(() {
                              tempFuels.contains(f)
                                  ? tempFuels.remove(f)
                                  : tempFuels.add(f);
                            }),
                          ),
                        ),

                        const Divider(),
                        _sectionTitle('Transmission'),
                        ...dummyCars
                            .map((c) => c.transmission)
                            .toSet()
                            .map(
                              (t) => CheckboxListTile(
                            title: Text(t),
                            value: tempTransmissions.contains(t),
                            onChanged: (_) => setSheetState(() {
                              tempTransmissions.contains(t)
                                  ? tempTransmissions.remove(t)
                                  : tempTransmissions.add(t);
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedBrands = tempBrands;
                            selectedFuels = tempFuels;
                            selectedTransmissions = tempTransmissions;
                            selectedSort = tempSort;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Apply Filters'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ================= HELPERS (FIXED) =================

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _sortRadio(
      String title,
      SortType value,
      SortType group,
      Function(SortType) onChanged,
      ) {
    return RadioListTile<SortType>(
      title: Text(title),
      value: value,
      groupValue: group,
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}
