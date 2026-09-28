import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DealerRatingRepository {
  DealerRatingRepository(this._firestore);
  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _ratingRef(
    String dealerId,
    String userId,
  ) {
    return _firestore
        .collection('dealers')
        .doc(dealerId)
        .collection('ratings')
        .doc(userId);
  }

  Future<bool> hasRated(String dealerId, String userId) async {
    final doc = await _ratingRef(dealerId, userId).get();
    return doc.exists;
  }

  Future<void> submitRating({
    required String dealerId,
    required String userId,
    required int rating,
    required String comment,
  }) {
    return _ratingRef(dealerId, userId).set({
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

final dealerRatingRepositoryProvider = Provider<DealerRatingRepository>((ref) {
  return DealerRatingRepository(FirebaseFirestore.instance);
});
