import '../../data/dummy_cars.dart';
import '../../models/car_model.dart';
import 'intent.dart';
import 'chat_context.dart';

class BotReply {
  final String text;
  final int confidence;
  BotReply(this.text, this.confidence);
}

class ResponseEngine {
  static BotReply reply(
      String input,
      Intent intent,
      ChatContext context,
      ) {
    final cars = _findCars(input);

    // ---------- GREETING ----------
    if (intent == Intent.greeting) {
      return BotReply(
        'Hi 👋 I can help you compare cars, check EMI, offers and budget options.',
        95,
      );
    }

    // ---------- MULTI STEP : BUDGET ----------
    if (intent == Intent.budget) {
      final budget = _extractNumber(input);
      if (budget == null) {
        context.waitingForBudget = true;
        return BotReply(
          'Sure 👍 What is your budget in lakhs?',
          70,
        );
      }

      context.budget = budget;
      context.waitingForBudget = false;

      final results = dummyCars
          .where((c) => c.basePrice / 100000 <= budget)
          .take(5)
          .toList();

      if (results.isEmpty) {
        return BotReply(
          'I couldn’t find good cars under ₹$budget lakh.',
          60,
        );
      }

      return BotReply(
        'Best cars under ₹$budget lakh:\n\n' +
            results
                .map((c) =>
            '• ${c.name} – ₹${(c.basePrice / 100000).toStringAsFixed(1)}L')
                .join('\n'),
        92,
      );
    }

    // ---------- COMPARE ----------
    if (intent == Intent.compare) {
      if (cars.length >= 2) {
        context.lastCar = cars[0].name;
        context.secondCar = cars[1].name;
        return BotReply(_compare(cars[0], cars[1]), 95);
      }

      context.waitingForCar = true;
      return BotReply(
        'Please tell me two cars to compare.\nExample: Nexon vs Brezza',
        65,
      );
    }

    // ---------- SINGLE CAR ----------
    if (cars.length == 1) {
      final c = cars.first;
      context.lastCar = c.name;

      switch (intent) {
        case Intent.price:
          return BotReply(
            '${c.name} costs around ₹${(c.basePrice / 100000).toStringAsFixed(1)} lakh.',
            90,
          );

        case Intent.rating:
          return BotReply(
            '${c.name} has a user rating of ${c.rating} ⭐',
            88,
          );

        case Intent.mileage:
          return BotReply(
            '${c.name} offers decent mileage suitable for daily use.',
            80,
          );

        case Intent.safety:
          return BotReply(
            '${c.name} is known for good build quality and safety.',
            85,
          );

        default:
          return BotReply(
            '${c.name} is priced at ₹${(c.basePrice / 100000).toStringAsFixed(1)} lakh.',
            75,
          );
      }
    }

    // ---------- FOLLOW-UP HANDLING ----------
    if (context.waitingForBudget) {
      final budget = _extractNumber(input);
      if (budget != null) {
        context.waitingForBudget = false;
        return reply('under $budget', Intent.budget, context);
      }
    }

    // ---------- FALLBACK ----------
    return BotReply(
      '''
I can help you with:
• Compare cars (Nexon vs Brezza)
• Best cars under budget
• EMI & pricing
• Safety & mileage

Try:
"Best car under 10 lakh"
"Nexon vs Seltos"
''',
      50,
    );
  }

  // ---------------- HELPERS ----------------

  static List<CarModel> _findCars(String text) {
    final lower = text.toLowerCase();
    return dummyCars.where((c) {
      final words = c.name.toLowerCase().split(' ');
      return words.any((w) => lower.contains(w));
    }).toList();
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
