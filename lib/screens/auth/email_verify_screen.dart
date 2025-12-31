import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({super.key});

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mark_email_read, size: 80),
            const SizedBox(height: 20),
            const Text(
              'A verification email has been sent.\nPlease verify to continue.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            if (loading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: () async {
                  setState(() => loading = true);
                  await user?.reload();

                  final refreshedUser =
                      FirebaseAuth.instance.currentUser;

                  if (refreshedUser!.emailVerified) {
                    setState(() => loading = false);
                  } else {
                    setState(() => loading = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email not verified yet'),
                      ),
                    );
                  }
                },
                child: const Text('I have verified'),
              ),

            TextButton(
              onPressed: () async {
                await user?.sendEmailVerification();
              },
              child: const Text('Resend Email'),
            ),
          ],
        ),
      ),
    );
  }
}
