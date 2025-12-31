import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final bool isAdmin;
  const SettingsScreen({super.key, required this.isAdmin});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool biometric = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    biometric = prefs.getBool('bio_${widget.isAdmin}') ?? false;
    setState(() {});
  }

  Future<void> _enableBiometric() async {
    final pinCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Set App Lock PIN'),
        content: TextField(
          controller: pinCtrl,
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 4,
          decoration: const InputDecoration(
            hintText: 'Enter 4-digit PIN',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (pinCtrl.text.length == 4) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('bio_${widget.isAdmin}', true);
    await prefs.setString('pin_${widget.isAdmin}', pinCtrl.text);

    setState(() => biometric = true);
  }

  Future<void> _disableBiometric() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('bio_${widget.isAdmin}');
    await prefs.remove('pin_${widget.isAdmin}');
    setState(() => biometric = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable App Lock (Fingerprint / PIN)'),
            value: biometric,
            onChanged: (v) {
              if (v) {
                _enableBiometric();
              } else {
                _disableBiometric();
              }
            },
          ),

          ListTile(
            title: const Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
