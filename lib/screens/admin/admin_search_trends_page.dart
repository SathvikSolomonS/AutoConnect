import 'package:flutter/material.dart';
import '../../services/search_analytics_service.dart';

class AdminSearchTrendsPage extends StatelessWidget {
  const AdminSearchTrendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Trends')),
      body: FutureBuilder<Map<String, int>>(
        future: SearchAnalyticsService.getStats(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final entries = snapshot.data!.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          if (entries.isEmpty) {
            return const Center(child: Text('No searches yet'));
          }

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final e = entries[index];
              return ListTile(
                title: Text(e.key),
                trailing: Text('${e.value} searches'),
              );
            },
          );
        },
      ),
    );
  }
}
