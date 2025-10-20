import 'package:flutter/material.dart';
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
        title: const Text('Canciones'),
        actions: const [
          _AddSongLogoButton(), // ← logo en la esquina
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

                final title =
                    (data['title'] ?? data['tittle'] ?? '(sin título)') as String;
                final lyrics = (data['lyrics'] as String?) ?? '';
                final cover  = (data['cover']  as String?) ?? '';

                return _SongCard(
                  title: title,
                  lyrics: lyrics,
                  coverUrl: cover,
                  onTap: () {
                    // Navigator.pushNamed(context, '/songDetails', arguments: doc.id);
                  },
                );
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
    // Si el asset no existe, muestra un ícono de respaldo
    return Image.asset(
      'assets/logo.png',
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) =>
          const Center(child: Icon(Icons.library_music)),
    );
  }
}

class _SongCard extends StatelessWidget {
  const _SongCard({
    required this.title,
    required this.lyrics,
    required this.coverUrl,
    this.onTap,
  });

  final String title;
  final String lyrics;
  final String coverUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 96,
          child: Row(
            children: [
              _CoverThumb(url: coverUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        lyrics,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Theme.of(context).hintColor),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.play_arrow),
                            tooltip: 'Reproducir',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.more_vert),
                            tooltip: 'Más opciones',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoverThumb extends StatelessWidget {
  const _CoverThumb({required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    const double side = 96;

    if (url.isEmpty) {
      return Container(
        width: side,
        height: side,
        color: Colors.black12,
        child: const Icon(Icons.music_note, size: 32),
      );
    }

    return SizedBox(
      width: side,
      height: side,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: Colors.black12,
          child: const Icon(Icons.broken_image),
        ),
      ),
    );
  }
}
