import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/auth/auth_choice_screen.dart';
import 'screens/customer/main_customer_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'security/app_lock_screen.dart';
import 'constants/admin_whitelist.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<bool> _isAppLockEnabled(bool isAdmin) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('bio_$isAdmin') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnap) {
        if (authSnap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 🔑 NOT LOGGED IN
        if (!authSnap.hasData) {
          return const AuthChoiceScreen();
        }

        final user = authSnap.data!;
        final email =
            user.email?.trim().toLowerCase() ?? '';

        // ✅ ADMIN CHECK (WHITELIST)
        final bool isAdmin = adminEmails.contains(email);

        debugPrint('LOGGED EMAIL => $email');
        debugPrint('IS ADMIN => $isAdmin');

        return FutureBuilder<bool>(
          future: _isAppLockEnabled(isAdmin),
          builder: (context, lockSnap) {
            if (!lockSnap.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final home = isAdmin
                ? const AdminDashboard()
                : const MainCustomerScreen();

            // 🔐 BIOMETRIC LOCK (ONLY IF ENABLED)
            if (lockSnap.data == true) {
              return AppLockScreen(
                isAdmin: isAdmin,
                child: home,
              );
            }

            // ✅ DIRECT ACCESS
            return home;
          },
        );
      },
    );
  }
}
