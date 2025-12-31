import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/offer_model.dart';

class OfferService {
  final _db = FirebaseFirestore.instance.collection('offers');

  Stream<List<OfferModel>> getActiveOffers() {
    return _db
        .where('active', isEqualTo: true)
        .snapshots()
        .map(
          (snap) => snap.docs
          .map((doc) => OfferModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Future<void> addOffer(OfferModel offer) async {
    await _db.add(offer.toMap());
  }

  Future<void> updateOffer(OfferModel offer) async {
    await _db.doc(offer.id).update(offer.toMap());
  }

  Future<void> deleteOffer(String id) async {
    await _db.doc(id).delete();
  }
}
