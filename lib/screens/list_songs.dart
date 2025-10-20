import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movilesejmplo1/firebase/songs_firebase.dart';

class ListSongs extends StatefulWidget {
  const ListSongs({super.key});

  @override
  State<ListSongs> createState() => _ListSongsState();
}

class _ListSongsState extends State<ListSongs> {
  final SongsFirebase songsFirebase = SongsFirebase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Songs'),
      ),
      body: StreamBuilder(
        stream: songsFirebase.selectSongs(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Text(snapshot.data!.docs[index].get('title'));
              },
            );
          } else {
            if (snapshot.hasError) {
              return const Center(child: Text('Error al cargar los datos'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
        },
      ),
    );
  }
}
