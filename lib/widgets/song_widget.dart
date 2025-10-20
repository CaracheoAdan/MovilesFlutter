import 'package:flutter/material.dart';

class SongWidget extends StatefulWidget {
  SongWidget(this.songData,{super.key});

  Map<String, dynamic> songData;

  @override
  State<SongWidget> createState() => _SongWidgetState();
}

class _SongWidgetState extends State<SongWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueGrey.withOpacity(0.3),
      ),
      child: Row(
        children: [
          FadeInImage(
            placeholder: AssetImage('assets/loadingbar.gif'), // Imagen local como placeholder
            image: NetworkImage(widget.songData['cover']), // Acceso al elemento 'cover'
          ), //Acceso al elemento 'cover'
          Column(
            children: [ListTile(
              title: Text(widget.songData['title']), //Acceso al elemento 'title'
              subtitle: Text(widget.songData['lyrics']), //Acceso al elemento 'lyrics'
            )],
          )        ],
      ),
    );
  }
}