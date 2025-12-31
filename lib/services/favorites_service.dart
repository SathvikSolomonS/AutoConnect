import 'package:cloud_firestore/cloud_firestore.dart';

class FavouriteService {
  static final _db = FirebaseFirestore.instance;

  static Future<void> syncFavourites(
      String uid, List<String> favs) async {
    await _db.collection('users').doc(uid).set(
      {'favourites': favs},
      SetOptions(merge: true),
    );
  }
}
