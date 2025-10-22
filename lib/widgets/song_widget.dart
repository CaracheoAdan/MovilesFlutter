import 'package:flutter/material.dart';

class SongWidget extends StatelessWidget {
  const SongWidget(this.songData, {super.key});

  final Map<String, dynamic> songData;

  @override
  Widget build(BuildContext context) {
    final title  = (songData['title'] ?? songData['tittle'] ?? '(sin título)') as String;
    final lyrics = (songData['lyrics'] as String?) ?? '';
    final cover  = (songData['cover']  as String?) ?? '';

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SizedBox(
        height: 96,
        child: Row(
          children: [
            _CoverThumb(url: cover),
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
