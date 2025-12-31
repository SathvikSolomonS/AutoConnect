import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;

  const RatingWidget({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        if (index + 1 <= rating.floor()) {
          return Icon(Icons.star, color: Colors.amber, size: size);
        } else if (index + 0.5 <= rating) {
          return Icon(Icons.star_half, color: Colors.amber, size: size);
        } else {
          return Icon(Icons.star_border, color: Colors.amber, size: size);
        }
      }),
    );
  }
}
