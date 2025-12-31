import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesProvider extends ChangeNotifier {
  final _uid = FirebaseAuth.instance.currentUser!.uid;
  final _ref = FirebaseFirestore.instance.collection('favorites');

  Set<String> _ids = {};

  Set<String> get ids => _ids;

  Future<void> load() async {
    final snap = await _ref.doc(_uid).get();
    _ids = Set<String>.from(snap.data()?['cars'] ?? []);
    notifyListeners();
  }

  Future<void> toggle(String carId) async {
    _ids.contains(carId) ? _ids.remove(carId) : _ids.add(carId);

    await _ref.doc(_uid).set({'cars': _ids.toList()});
    notifyListeners();
  }

  bool isFav(String id) => _ids.contains(id);
}
