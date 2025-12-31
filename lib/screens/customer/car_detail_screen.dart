import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/car_model.dart';
import '../../models/offer_model.dart';
import '../../services/offer_services.dart';
import 'dart:math';

class CarDetailScreen extends StatefulWidget {
  final CarModel car;
  const CarDetailScreen({super.key, required this.car});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen>
    with SingleTickerProviderStateMixin {
  double userRating = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadUserRating();
  }

  // ---------------- LOAD USER RATING ----------------
  Future<void> _loadUserRating() async {
    final prefs = await SharedPreferences.getInstance();
    userRating = prefs.getDouble('rating_${widget.car.id}') ?? 0;
    setState(() {});
  }

  // ---------------- SAVE USER RATING ----------------
  Future<void> _saveUserRating(double rating) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('rating_${widget.car.id}', rating);
    setState(() => userRating = rating);
  }

  // ---------------- ADD TO CART ----------------
  Future<void> _addToCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cart = prefs.getStringList('cart_cars') ?? [];
    if (!cart.contains(widget.car.id)) {
      cart.add(widget.car.name);
      await prefs.setStringList('cart_cars', cart);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to interest list')),
    );
  }

  // ---------------- EMI CALCULATION ----------------
  void _openEmiCalculator() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _EmiSheet(price: widget.car.basePrice),
    );
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;

    return Scaffold(
      appBar: AppBar(
        title: Text(car.name),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Offers'),
            Tab(text: 'Key Specs'),
            Tab(text: 'Versions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _overviewTab(car),
          _offersTab(),          // ✅ FIXED
          _specsTab(car),
          _versionsTab(car),
        ],
      ),
    );
  }

  // ================= OVERVIEW =================
  Widget _overviewTab(CarModel car) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        car.images.isNotEmpty
            ? Image.network(
          car.images.first,
          height: 220,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(),
        )
            : _placeholder(),

        const SizedBox(height: 16),

        Text(
          car.name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 6),

        Text(
          '₹ ${(car.basePrice / 100000).toStringAsFixed(1)} L',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.deepPurple,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            _buildStarRow(car.rating),
            const SizedBox(width: 8),
            Text(car.rating.toStringAsFixed(1)),
          ],
        ),

        const Divider(height: 32),

        const Text(
          'Your Rating',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        Row(
          children: List.generate(5, (i) {
            return IconButton(
              icon: Icon(
                i < userRating ? Icons.star : Icons.star_border,
                color: Colors.orange,
              ),
              onPressed: () => _saveUserRating(i + 1.0),
            );
          }),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _openEmiCalculator,
                child: const Text('Calculate EMI'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: _addToCart,
                child: const Text('Add'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= OFFERS (FIXED) =================
  Widget _offersTab() {
    return StreamBuilder<List<OfferModel>>(
      stream: OfferService().getActiveOffers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No offers available at the moment',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        final offers = snapshot.data!;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: offers.map((offer) {
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(Icons.local_offer, color: Colors.green),
                title: Text(
                  offer.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${offer.description}\nValid till: ${offer.validTill}',
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // ================= SPECS =================
  Widget _specsTab(CarModel car) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: car.specs.entries
          .map(
            (e) => ListTile(
          title: Text(e.key),
          trailing: Text(e.value.toString()),
        ),
      )
          .toList(),
    );
  }

  // ================= VERSIONS =================
  Widget _versionsTab(CarModel car) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: car.variants.map((v) {
        return Card(
          child: ListTile(
            title: Text(v['name']),
            trailing: Text(
              '₹ ${(v['price'] / 100000).toStringAsFixed(1)} L',
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStarRow(double rating) {
    return Row(
      children: List.generate(5, (i) {
        return Icon(
          i < rating.round() ? Icons.star : Icons.star_border,
          color: Colors.amber,
        );
      }),
    );
  }

  Widget _placeholder() {
    return Container(
      height: 220,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: const Icon(Icons.directions_car, size: 60, color: Colors.grey),
    );
  }
}

//////////////////////////////////////////////////////////////
/// EMI BOTTOM SHEET (UNCHANGED)
//////////////////////////////////////////////////////////////

class _EmiSheet extends StatefulWidget {
  final double price;
  const _EmiSheet({required this.price});

  @override
  State<_EmiSheet> createState() => _EmiSheetState();
}

class _EmiSheetState extends State<_EmiSheet> {
  double interest = 9;
  int years = 5;

  @override
  Widget build(BuildContext context) {
    final loan = widget.price * 0.8;
    final r = interest / 12 / 100;
    final n = years * 12;

    final emi =
        (loan * r * pow(1 + r, n)) / (pow(1 + r, n) - 1);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'EMI Calculator',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          Slider(
            value: interest,
            min: 5,
            max: 15,
            divisions: 10,
            label: '${interest.toStringAsFixed(1)}%',
            onChanged: (v) => setState(() => interest = v),
          ),
          Text('Interest: ${interest.toStringAsFixed(1)}%'),

          Slider(
            value: years.toDouble(),
            min: 1,
            max: 7,
            divisions: 6,
            label: '$years years',
            onChanged: (v) => setState(() => years = v.toInt()),
          ),
          Text('Tenure: $years years'),

          const SizedBox(height: 10),

          Text(
            'Monthly EMI: ₹ ${emi.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
