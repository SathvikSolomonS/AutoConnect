import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// 🔐 GUARANTEED authentication
  /// Uses:
  /// - Fingerprint OR
  /// - Face unlock OR
  /// - Device PIN / Pattern
  Future<bool> authenticate() async {
    try {
      final isSupported = await _auth.isDeviceSupported();
      if (!isSupported) return false;

      return await _auth.authenticate(
        localizedReason: 'Unlock app to continue',
        options: const AuthenticationOptions(
          biometricOnly: false, // 🔥 THIS IS THE KEY
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } catch (e) {
      debugPrint('Auth error: $e');
      return false;
    }
  }
}
