import 'package:flutter/material.dart';
import 'package:movilesejmplo1/database/movies_databases.dart';

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({super.key});

  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  MoviesDatabase? moviesDb;
  DateTime selectedDate = DateTime.now();
  TextEditingController conTitle = TextEditingController();
  TextEditingController conTime = TextEditingController();
  TextEditingController conRelease = TextEditingController();

  @override
  void initState() {
    super.initState();
    moviesDb = MoviesDatabase();
  }

  @override
  Widget build(BuildContext context) {
    conRelease.text = selectedDate.toLocal().toString().split(' ')[0];

    final txtTitle = TextFormField(
      controller: conTitle,
      decoration: InputDecoration(hintText: "Titulo de la pelicula."),
    );

    final txtTime = TextFormField(
      controller: conTime,
      decoration: InputDecoration(hintText: "Duracion de la pelicula"),
    );

    final txtRelease = TextFormField(
      controller: conRelease,
      decoration: InputDecoration(hintText: "Fecha de lanzamiento"),
      onTap: () => _selectedDate(context),
    );

    final btnGuardar = ElevatedButton(
      onPressed: () {
        moviesDb!
            .INSERT("tblMovies", {
              "nameMovie": conTitle.text,
              "time": conTime.text,
              "releaseDate": conRelease.text,
            })
            .then((value) => Navigator.pop(context));
      },
      child: Text("Guardar"),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Insertar pelicula")),
      body: ListView(
        shrinkWrap: true,
        children: [txtTitle, txtTime, txtRelease, btnGuardar],
      ),
    );
  }

  _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2026),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
