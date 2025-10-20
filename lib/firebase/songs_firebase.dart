import 'package:cloud_firestore/cloud_firestore.dart';

class SongsFirebase {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference? songsCollection;

  SongsFirebase() {
    songsCollection = firebaseFirestore.collection('songs');
  }

  Future<void> addSong(Map<String, dynamic> songData) async {
    songsCollection!.doc().set(songData);
  }

  Future<void> updateSong(String songId, Map<String, dynamic> songData) async {
    songsCollection!.doc(songId).update(songData);
  }
  Future<void> deleteSong(String songId) async {
    songsCollection!.doc(songId).delete();
  }
  Stream<QuerySnapshot> selectSongs() {
    return songsCollection!.snapshots();
  }


}

  
