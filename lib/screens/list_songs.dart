import 'package:flutter/material.dart';
import 'package:movilesejmplo1/firebase/songs_firebase.dart';
// Ajusta la ruta si tu archivo está en otro folder:
import 'package:movilesejmplo1/widgets/song_widget.dart';

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
        title: const Text('Canciones'),
        actions: const [
          _AddSongLogoButton(),
        ],
      ),
      body: StreamBuilder(
        stream: songsFirebase.selectSongs(), // sin límite
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los datos'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Sin canciones'));
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No hay canciones'));
          }

          return Scrollbar(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
              itemCount: docs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = (doc.data() as Map<String, dynamic>? ) ?? {};

                // Normaliza el campo por si existe 'tittle'
                if (!data.containsKey('title') && data.containsKey('tittle')) {
                  data['title'] = data['tittle'];
                }
                // Pasa también el id del doc si te sirve en acciones
                data['__id'] = doc.id;

                return SongWidget(data);
              },
            ),
          );
        },
      ),
    );
  }
}

class _AddSongLogoButton extends StatelessWidget {
  const _AddSongLogoButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => Navigator.pushNamed(context, '/addsong'),
        child: SizedBox(
          width: 36,
          height: 36,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: _LogoImage(),
          ),
        ),
      ),
    );
  }
}

class _LogoImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logo.png',
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          const Center(child: Icon(Icons.library_music)),
    );
  }
}
