import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationsFirebase {
  final _db = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('reservations').withConverter<Map<String, dynamic>>(
        fromFirestore: (snap, _) => snap.data() ?? {},
        toFirestore: (data, _) => data,
      );

  /// Crea con referencia al producto y dayKey para el calendario
  Future<String> addReservation({
    required String userId,
    required String productId,
    required DateTime start,
    required DateTime end,
    String status = 'confirmed',
  }) async {
    final productRef = _db.collection('products').doc(productId);
    final dayKey = _yyyyMmDd(start);

    final doc = await _col.add({
      'userId': userId,
      'product': productRef,        // relación por Reference
      'start': Timestamp.fromDate(start),
      'end': Timestamp.fromDate(end),
      'status': status,
      'dayKey': dayKey,
    });
    return doc.id;
  }

  Future<void> updateReservation(String id, Map<String, dynamic> data) {
    return _col.doc(id).update(data);
  }

  Future<void> deleteReservation(String id) {
    return _col.doc(id).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamByDay(String dayKey) {
    return _col.where('dayKey', isEqualTo: dayKey).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamByProduct(String productId) {
    final ref = _db.collection('products').doc(productId);
    return _col.where('product', isEqualTo: ref)
               .orderBy('start')
               .snapshots();
  }

  static String _yyyyMmDd(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
