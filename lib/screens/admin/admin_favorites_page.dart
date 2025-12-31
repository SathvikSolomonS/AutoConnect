import 'package:flutter/material.dart';
import '../../services/local_analytics_service.dart';

class AdminFavoritesPage extends StatelessWidget {
  const AdminFavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Cars')),
      body: FutureBuilder<Map<String, int>>(
        future: LocalAnalyticsService.getFavoriteStats(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final entries = snapshot.data!.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          if (entries.isEmpty) {
            return const Center(child: Text('No favorites yet'));
          }

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final e = entries[index];
              return ListTile(
                title: Text(e.key),
                trailing: Text('${e.value} likes'),
              );
            },
          );
        },
      ),
    );
  }
}
