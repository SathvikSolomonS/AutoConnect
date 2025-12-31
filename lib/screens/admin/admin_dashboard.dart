import 'package:flutter/material.dart';

import '../../services/user_analytics_service.dart';
import '../../services/local_analytics_service.dart';
import '../../services/search_analytics_service.dart';
import '../../services/cart_analytics_service.dart';

import '../settings/settings_screen.dart';
import 'admin_car_list_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(isAdmin: true),
                ),
              );
            },
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DashboardCard(
            title: '👥 Total Users',
            subtitle: 'Registered users on this device',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const _TotalUsersPage(),
                ),
              );
            },
          ),

          _DashboardCard(
            title: '🚘 Added Cars',
            subtitle: 'Cars added by customers',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const _AddedCarsPage(),
                ),
              );
            },
          ),

          _DashboardCard(
            title: '🔍 Search Trends',
            subtitle: 'Most searched cars',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const _SearchTrendsPage(),
                ),
              );
            },
          ),

          _DashboardCard(
            title: '🚗 Manage Cars',
            subtitle: 'Add / Edit / Delete cars',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminCarListScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// ---------------- CARD ----------------
class _DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

/// ---------------- TOTAL USERS ----------------
class _TotalUsersPage extends StatelessWidget {
  const _TotalUsersPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Total Users')),
      body: FutureBuilder<int>(
        future: UserAnalyticsService.getTotalUsers(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Text(
              '👥\n\nTotal Registered Users\n\n${snap.data}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ---------------- SEARCH TRENDS ----------------
class _SearchTrendsPage extends StatelessWidget {
  const _SearchTrendsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Trends')),
      body: FutureBuilder<Map<String, int>>(
        future: SearchAnalyticsService.getStats(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.data!.isEmpty) {
            return const Center(child: Text('No searches yet'));
          }

          final entries = snap.data!.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          return ListView(
            children: entries.map((e) {
              return ListTile(
                title: Text(e.key),
                trailing: Text('${e.value} searches'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

/// ---------------- ADDED CARS (CUSTOMER) ----------------
class _AddedCarsPage extends StatelessWidget {
  const _AddedCarsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Added Cars')),
      body: FutureBuilder<Map<String, int>>(
        future: CartAnalyticsService.getAddedCarsStats(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.data!.isEmpty) {
            return const Center(
              child: Text('No cars added by users yet'),
            );
          }

          final entries = snap.data!.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          return ListView(
            children: entries.map((e) {
              return ListTile(
                title: Text(e.key),
                trailing: Text('${e.value} users'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
