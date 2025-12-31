import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/biometric_service.dart';

class AppLockScreen extends StatefulWidget {
  final Widget child;
  final bool isAdmin;

  const AppLockScreen({
    super.key,
    required this.child,
    required this.isAdmin,
  });

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  final _biometricService = BiometricService();
  final _pinCtrl = TextEditingController();

  bool unlocked = false;
  String? storedPin;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();

    final enabled = prefs.getBool('bio_${widget.isAdmin}') ?? false;
    storedPin = prefs.getString('pin_${widget.isAdmin}');

    if (!enabled) {
      setState(() => unlocked = true);
      return;
    }

    // 🔐 Try system auth immediately
    final ok = await _biometricService.authenticate();
    if (ok) {
      setState(() => unlocked = true);
    }
  }

  void _unlockWithPin() {
    if (_pinCtrl.text == storedPin) {
      setState(() => unlocked = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrect PIN')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (unlocked) return widget.child;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock, size: 72),
              const SizedBox(height: 16),

              const Text(
                'App Locked',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              /// 🔑 Retry system auth
              ElevatedButton.icon(
                icon: const Icon(Icons.fingerprint),
                label: const Text('Unlock with Biometrics'),
                onPressed: () async {
                  final ok = await _biometricService.authenticate();
                  if (ok) {
                    setState(() => unlocked = true);
                  }
                },
              ),

              const SizedBox(height: 24),

              /// 🔢 PIN fallback
              TextField(
                controller: _pinCtrl,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: 'Enter App PIN',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _unlockWithPin,
                  child: const Text('Unlock'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

