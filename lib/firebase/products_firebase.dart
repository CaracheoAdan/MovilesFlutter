import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsFirebase {
  final _db = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _col =>
      _db.collection('products').withConverter<Map<String, dynamic>>(
        fromFirestore: (snap, _) => snap.data()!,
        toFirestore: (data, _) => data,
      );
  Future<String> addProduct(Map<String, dynamic> data) async {
    final doc = await _col.add(data);
    return doc.id;
  }
  Future<void> deleteProduct(String id) async {
    await _col.doc(id).delete();
  }
  Future<Map<String, dynamic>?> getProductById(String id) async {
    final doc = await _col.doc(id).get();
    return doc.data();
  }
  //Lista de productos
  Stream<QuerySnapshot<Map<String, dynamic>>> streamAll({String ? categoryId, bool? active}){
    Query<Map<String, dynamic>> q= _col;
    if(categoryId != null) q = q.where('categoryId', isEqualTo: categoryId);
    if(active != null) q = q.where('active', isEqualTo: active);
    return q.snapshots();
  }
  Future<bool> canSafeDelete(String productId) async {
    final ref = _col.doc(productId);
    // reservas activas
    final res = await _db.collection('reservations')
        .where('product', isEqualTo: ref)
        .where('status', isEqualTo: 'confirmed')
        .limit(1).get();
    if (res.docs.isNotEmpty) return false;

    // options
    final opts = await _db.collection('productOptions')
        .where('productId', isEqualTo: productId)
        .limit(1).get();
    if (opts.docs.isNotEmpty) return false;

    return true;
  } // Class implementation
}