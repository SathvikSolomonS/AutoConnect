import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppAuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user;
  bool isAdmin = false;
  bool isLoggedIn = false;
  bool loading = false;

  AppAuthProvider() {
    _auth.authStateChanges().listen(_onAuthChanged);
  }

  Future<void> _onAuthChanged(User? firebaseUser) async {
    user = firebaseUser;

    if (user == null) {
      isLoggedIn = false;
      isAdmin = false;
      notifyListeners();
      return;
    }

    isLoggedIn = true;

    final snap =
    await _firestore.collection('users').doc(user!.uid).get();

    isAdmin = snap.data()?['role'] == 'admin';
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    loading = true;
    notifyListeners();

    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    loading = false;
    notifyListeners();
  }

  Future<void> register({
    required String email,
    required String password,
    required bool isAdmin,
  }) async {
    loading = true;
    notifyListeners();

    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await cred.user!.sendEmailVerification();

    await _firestore.collection('users').doc(cred.user!.uid).set({
      'email': email,
      'role': isAdmin ? 'admin' : 'customer',
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _auth.signOut(); // 🔒 force verify before login

    loading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
