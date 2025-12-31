class OfferModel {
  final String id;
  final String title;
  final String description;
  final String validTill;
  final bool active;

  OfferModel({
    required this.id,
    required this.title,
    required this.description,
    required this.validTill,
    required this.active,
  });

  factory OfferModel.fromMap(String id, Map<String, dynamic> map) {
    return OfferModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      validTill: map['validTill'] ?? '',
      active: map['active'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'validTill': validTill,
      'active': active,
    };
  }
}
