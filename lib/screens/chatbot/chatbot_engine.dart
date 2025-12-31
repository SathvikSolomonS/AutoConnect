import '../../models/car_model.dart';

class ChatbotEngine {
  static String reply(String input, List<CarModel> cars) {
    final text = input.toLowerCase();

    final foundCars = _findCars(text, cars);

    // -------- COMPARISON --------
    if (text.contains('vs') || text.contains('compare')) {
      if (foundCars.length >= 2) {
        return _compare(foundCars[0], foundCars[1]);
      }
      return 'Please mention two cars. Example: Nexon vs Brezza';
    }

    // -------- BUDGET --------
    if (text.contains('under') || text.contains('below')) {
      final budget = _extractNumber(text);
      if (budget != null) {
        final results = cars
            .where((c) => c.basePrice <= budget * 100000)
            .toList();

        if (results.isEmpty) {
          return 'No good cars found under ₹$budget lakh.';
        }

        return 'Best cars under ₹$budget lakh:\n\n' +
            results
                .take(5)
                .map((c) =>
            '• ${c.name} – ₹${(c.basePrice / 100000).toStringAsFixed(1)}L')
                .join('\n');
      }
    }

    // -------- MILEAGE --------
    if (text.contains('mileage')) {
      if (foundCars.isNotEmpty) {
        return '${foundCars[0].name} offers decent mileage and is suitable for daily use.';
      }
      return 'Tell me the car name to check mileage.';
    }

    // -------- SAFETY --------
    if (text.contains('safe') || text.contains('safety')) {
      if (foundCars.isNotEmpty) {
        return '${foundCars[0].name} is known for good build quality and safety.';
      }
      return 'Tata Nexon and Punch are known for strong safety.';
    }

    // -------- CITY --------
    if (text.contains('city')) {
      return 'For city driving, compact cars like Punch, Baleno, and Sonet are ideal.';
    }

    // -------- FAMILY --------
    if (text.contains('family')) {
      return 'For family use, Creta, Seltos, and Ertiga offer good comfort and space.';
    }

    // -------- SINGLE CAR INFO --------
    if (foundCars.length == 1) {
      final c = foundCars.first;
      return '${c.name} costs around ₹${(c.basePrice / 100000).toStringAsFixed(1)} lakh.\n'
          'Fuel: ${c.fuel}\n'
          'Rating: ${c.rating}⭐';
    }

    // -------- FALLBACK --------
    return 'You can ask me:\n'
        '• Nexon vs Brezza\n'
        '• Best car under 10 lakh\n'
        '• Mileage of Nexon\n'
        '• Is Nexon safe?\n'
        '• Best family car';
  }

  // ================= HELPERS =================

  static List<CarModel> _findCars(String text, List<CarModel> cars) {
    return cars
        .where((c) =>
        text.contains(c.name.toLowerCase().split(' ').first))
        .toList();
  }

  static String _compare(CarModel a, CarModel b) {
    return '''
${a.name} vs ${b.name}

💰 Price:
• ${a.name}: ₹${(a.basePrice / 100000).toStringAsFixed(1)}L
• ${b.name}: ₹${(b.basePrice / 100000).toStringAsFixed(1)}L

⭐ Rating:
• ${a.name}: ${a.rating}⭐
• ${b.name}: ${b.rating}⭐

🏆 Verdict:
${a.rating >= b.rating ? a.name : b.name} is the better overall choice.
''';
  }

  static int? _extractNumber(String text) {
    final match = RegExp(r'\d+').firstMatch(text);
    return match != null ? int.parse(match.group(0)!) : null;
  }
}
