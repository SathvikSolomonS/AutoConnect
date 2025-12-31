
class ReviewModel {
  final String text;
  final double rating;

  ReviewModel({required this.text, required this.rating});

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'rating': rating,
    };
  }
}
