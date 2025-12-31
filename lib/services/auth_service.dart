import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔐 LOGIN (BLOCK IF EMAIL NOT VERIFIED)
  Future<User?> login(String email, String password) async {
    final res = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = res.user;

    if (user != null && !user.emailVerified) {
      await _auth.signOut();
      throw FirebaseAuthException(
        code: 'email-not-verified',
        message: 'Please verify your email before logging in.',
      );
    }

    return user;
  }

  // 📝 REGISTER + SEND VERIFICATION EMAIL
  Future<User?> register(
      String email,
      String password,
      String role,
      ) async {
    final res = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = res.user;

    if (user != null) {
      // Send verification email
      await user.sendEmailVerification();

      // Save user role in Firestore
      await _db.collection('users').doc(user.uid).set({
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return user;
  }

  // 🔍 FETCH USER ROLE
  Future<String> fetchUserRole(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data()?['role'] ?? 'customer';
  }

  // 🚪 LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }
}
