import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movilesejmplo1/firebase/songs_firebase.dart';

class AddSongScreen extends StatefulWidget {
  const AddSongScreen({super.key});

  @override
  State<AddSongScreen> createState() => _AddSongScreenState();
}

class _AddSongScreenState extends State<AddSongScreen> {
  final _formKey = GlobalKey<FormState>();

  final conCover = TextEditingController();
  final conDuration = TextEditingController();
  final conLyrics = TextEditingController();
  final conTitle = TextEditingController();

  late final SongsFirebase songsFirebase;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    songsFirebase = SongsFirebase();
    // Redibuja para preview al cambiar cover
    conCover.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    conCover.dispose();
    conDuration.dispose();
    conLyrics.dispose();
    conTitle.dispose();
    super.dispose();
  }

  bool _isLikelyBase64(String s) {
    // Heurística simple para no crashear: empieza con data: y contiene ";base64,"
    return s.startsWith('data:') && s.contains(';base64,');
  }

  ImageProvider? _coverImageProvider() {
    final cover = conCover.text.trim();
    if (cover.isEmpty) return null;
    if (_isLikelyBase64(cover)) {
      try {
        final base64Part = cover.split(',').last;
        final bytes = base64Decode(base64Part);
        return MemoryImage(bytes);
      } catch (_) {
        return null;
      }
    }
    // Asumimos URL
    return NetworkImage(cover);
  }

  Future<void> _save() async {
    if (_saving) return;
    if (!_formKey.currentState!.validate()) return;

    final title = conTitle.text.trim();
    final lyrics = conLyrics.text.trim();
    final durationStr = conDuration.text.trim();
    final cover = conCover.text.trim();

    int? durationMinutes;
    if (durationStr.isNotEmpty) {
      durationMinutes = int.tryParse(durationStr);
      if (durationMinutes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La duración debe ser un número entero')),
        );
        return;
      }
    }

    if (cover.isNotEmpty && cover.length > 500000) {
      // Firestore tiene límite de 1 MiB por documento
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El cover parece muy grande. Sube la imagen a Storage y guarda la URL.'),
          duration: Duration(seconds: 4),
        ),
      );
    }

    try {
      setState(() => _saving = true);

      await songsFirebase.addSong({
        // Usamos `tittle` porque así está en tu base
        'tittle': title,
        'lyrics': lyrics,
        'duration': durationMinutes,
        'cover': cover,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Song Added Successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imgProvider = _coverImageProvider();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new song'),
        actions: [
          IconButton(
            onPressed: _saving ? null : _save,
            tooltip: 'Guardar',
            icon: _saving
                ? const SizedBox(
                    width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.check),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saving ? null : _save,
        icon: _saving
            ? const SizedBox(
                width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.save),
        label: const Text('Guardar'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            // PREVIEW CARD
            Card(
              elevation: 2,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  // Imagen de portada
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: imgProvider != null
                        ? Image(
                            image: imgProvider,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _PreviewPlaceholder(),
                          )
                        :  _PreviewPlaceholder(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Vista previa del cover.\nPega una URL de imagen o un data URI (base64 corto).',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Theme.of(context).hintColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // FORM CARD
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: conTitle,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "Song's title",
                          prefixIcon: Icon(Icons.title),
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'El título es obligatorio' : null,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: conLyrics,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: "Song's lyrics",
                          alignLabelWithHint: true,
                          prefixIcon: Icon(Icons.lyrics),
                          border: OutlineInputBorder(),
                          helperText: 'Puedes pegar un extracto; el texto completo puede ser pesado.',
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Las letras son obligatorias' : null,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: conDuration,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: "Song's duration in minutes",
                          prefixIcon: Icon(Icons.timer),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: conCover,
                        decoration: const InputDecoration(
                          labelText: 'Cover (URL recomendada)',
                          prefixIcon: Icon(Icons.image_outlined),
                          border: OutlineInputBorder(),
                          helperText: 'Mejor sube a Firebase Storage y pega aquí el link público.',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // CONSEJO
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.tips_and_updates_outlined),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Por el momento las imagenes se suben con la URL de la imagen.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).hintColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
      child: const Center(
        child: Icon(Icons.music_note, size: 56),
      ),
    );
  }
}
