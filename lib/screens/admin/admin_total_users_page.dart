import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminTotalUsersPage extends StatelessWidget {
  const AdminTotalUsersPage({super.key});

  Future<int> _getTotalUsers() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('total_users') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Total Users'),
      ),
      body: Center(
        child: FutureBuilder<int>(
          future: _getTotalUsers(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.people,
                  size: 80,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Total Registered Users',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  snapshot.data.toString(),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
