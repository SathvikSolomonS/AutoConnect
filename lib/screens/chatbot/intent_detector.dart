import 'intent.dart';

class IntentDetector {
  static Intent detect(String input) {
    final text = input.toLowerCase();

    if (text.contains('hi') || text.contains('hello')) {
      return Intent.greeting;
    }

    if (text.contains('under') || text.contains('below')) {
      return Intent.budget;
    }

    if (text.contains('vs') || text.contains('compare')) {
      return Intent.compare;
    }

    if (text.contains('rating')) {
      return Intent.rating;
    }

    if (text.contains('mileage')) {
      return Intent.mileage;
    }

    if (text.contains('price') || text.contains('cost')) {
      return Intent.price;
    }

    if (text.contains('safe') || text.contains('safety')) {
      return Intent.safety;
    }

    if (text.contains('family')) {
      return Intent.family;
    }

    return Intent.unknown;
  }
}
