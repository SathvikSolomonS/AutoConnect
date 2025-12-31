class CarModel {
  final String id;
  final String brand;
  final String name;
  final double basePrice;
  final String fuel;
  final String transmission;
  final double rating;
  final List<String> images;
  final Map<String, dynamic> specs;
  final List<Map<String, dynamic>> variants;
  final List<String> offers;

  CarModel({
    required this.id,
    required this.brand,
    required this.name,
    required this.basePrice,
    required this.fuel,
    required this.transmission,
    required this.rating,
    required this.images,
    required this.specs,
    required this.variants,
    required this.offers,
  });

  factory CarModel.fromMap(String id, Map<String, dynamic> map) {
    return CarModel(
      id: id,
      brand: map['brand'] ?? '',
      name: map['name'] ?? '',
      basePrice: (map['basePrice'] ?? 0).toDouble(),
      fuel: map['fuel'] ?? '',
      transmission: map['transmission'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      images: List<String>.from(map['images'] ?? []),
      specs: Map<String, dynamic>.from(map['specs'] ?? {}),
      variants: List<Map<String, dynamic>>.from(map['variants'] ?? []),
      offers: List<String>.from(map['offers'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'brand': brand,
      'name': name,
      'basePrice': basePrice,
      'fuel': fuel,
      'transmission': transmission,
      'rating': rating,
      'images': images,
      'specs': specs,
      'variants': variants,
      'offers': offers,
    };
  }
}
