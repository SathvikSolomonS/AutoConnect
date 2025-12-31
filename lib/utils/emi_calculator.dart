import 'dart:math';
import 'package:flutter/material.dart';

class EmiCalculatorScreen extends StatefulWidget {
  final double price;
  const EmiCalculatorScreen({super.key, required this.price});

  @override
  State<EmiCalculatorScreen> createState() =>
      _EmiCalculatorScreenState();
}

class _EmiCalculatorScreenState extends State<EmiCalculatorScreen> {
  double interest = 9;
  int years = 5;
  double emi = 0;

  void calculate() {
    final r = interest / 12 / 100;
    final n = years * 12;
    emi = (widget.price * r * pow(1 + r, n)) /
        (pow(1 + r, n) - 1);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EMI Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Price: ₹${widget.price.toInt()}'),
            Slider(
              value: interest,
              min: 6,
              max: 15,
              divisions: 9,
              label: '${interest.toInt()}%',
              onChanged: (v) => setState(() => interest = v),
            ),
            Slider(
              value: years.toDouble(),
              min: 1,
              max: 7,
              divisions: 6,
              label: '$years years',
              onChanged: (v) => setState(() => years = v.toInt()),
            ),
            ElevatedButton(
              onPressed: calculate,
              child: const Text('Calculate'),
            ),
            if (emi > 0)
              Text(
                'Monthly EMI: ₹${emi.toStringAsFixed(0)}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
