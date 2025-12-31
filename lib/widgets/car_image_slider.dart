import 'package:flutter/material.dart';

class CarImageSlider extends StatelessWidget {
  final List<String> images;
  const CarImageSlider({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (_, index) {
          return Image.network(
            images[index],
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
            const Center(child: Icon(Icons.broken_image, size: 50)),
          );
        },
      ),
    );
  }
}
