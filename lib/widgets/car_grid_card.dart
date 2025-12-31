import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/car_model.dart';

class CarGridCard extends StatefulWidget {
  final CarModel car;
  final VoidCallback onTap;

  const CarGridCard({
    super.key,
    required this.car,
    required this.onTap,
  });

  @override
  State<CarGridCard> createState() => _CarGridCardState();
}

class _CarGridCardState extends State<CarGridCard>
    with SingleTickerProviderStateMixin {
  bool isFavourite = false;
  double displayRating = 0;

  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scale = Tween<double>(begin: 1, end: 1.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final favs = prefs.getStringList('favourites') ?? [];
    final savedRating =
    prefs.getDouble('rating_${widget.car.id}');

    if (!mounted) return;

    setState(() {
      isFavourite = favs.contains(widget.car.id);
      displayRating = savedRating ?? widget.car.rating;
    });
  }

  Future<void> _toggleFavourite() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favourites') ?? [];

    if (isFavourite) {
      favs.remove(widget.car.id);
      _showToast('Removed from favourites');
    } else {
      favs.add(widget.car.id);
      _controller.forward(from: 0);
      _showToast('Saved to favourites');
    }

    await prefs.setStringList('favourites', favs);

    if (!mounted) return;
    setState(() => isFavourite = !isFavourite);
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(milliseconds: 900),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;

    return InkWell(
      onTap: widget.onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= IMAGE + HEART =================
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    car.images.first,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(
                      height: 120,
                      child: Center(
                        child: Icon(Icons.directions_car, size: 40),
                      ),
                    ),
                  ),
                ),

                // ❤️ HEART (FIXED, ALWAYS VISIBLE)
                Positioned(
                  top: 8,
                  right: 8,
                  child: SizedBox(
                    width: 42,
                    height: 42,
                    child: ScaleTransition(
                      scale: _scale,
                      child: Material(
                        color: Colors.black.withOpacity(0.5),
                        shape: const CircleBorder(),
                        child: IconButton(
                          iconSize: 22,
                          icon: Icon(
                            isFavourite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                            isFavourite ? Colors.red : Colors.white,
                          ),
                          onPressed: _toggleFavourite,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ================= DETAILS =================
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  // ⭐ RATING (ALWAYS VISIBLE)
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        return Icon(
                          i < displayRating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          size: 16,
                          color: Colors.amber,
                        );
                      }),
                      const SizedBox(width: 4),
                      Text(
                        displayRating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '₹ ${(car.basePrice / 100000).toStringAsFixed(1)} L',
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
