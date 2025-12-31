import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<String> selectedFuels;
  final Function(List<String>) onApply;

  const FilterBottomSheet({
    super.key,
    required this.selectedFuels,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late List<String> fuels;

  final List<String> allFuels = ['Petrol', 'Diesel', 'Electric'];

  @override
  void initState() {
    super.initState();
    fuels = List.from(widget.selectedFuels);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filters',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(),

          const SizedBox(height: 10),
          const Text('Fuel Type', style: TextStyle(fontWeight: FontWeight.w600)),

          const SizedBox(height: 10),
          ...allFuels.map(
                (fuel) => CheckboxListTile(
              title: Text(fuel),
              value: fuels.contains(fuel),
              onChanged: (val) {
                setState(() {
                  val! ? fuels.add(fuel) : fuels.remove(fuel);
                });
              },
            ),
          ),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(fuels);
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
