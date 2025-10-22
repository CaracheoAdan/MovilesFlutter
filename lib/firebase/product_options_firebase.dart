import 'package:cloud_firestore/cloud_firestore.dart';

class ProductOptionsFirebase {
  final _db = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('productOptions').withConverter<Map<String, dynamic>>(
        fromFirestore: (snap, _) => snap.data() ?? {},
        toFirestore: (data, _) => data,
      );

  Future<String> addOption(Map<String, dynamic> data) async {
    final doc = await _col.add(data);
    return doc.id;
  }

  Future<void> updateOption(String optionId, Map<String, dynamic> data) {
    return _col.doc(optionId).update(data);
  }

  Future<void> deleteOption(String optionId) {
    return _col.doc(optionId).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamByProduct(String productId) {
    return _col.where('productId', isEqualTo: productId).snapshots();
  }
}
