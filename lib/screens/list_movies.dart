import 'package:flutter/material.dart';
import 'package:movilesejmplo1/database/movies_databases.dart';

class ListMovies extends StatefulWidget {
  const ListMovies({super.key});

  @override
  State<ListMovies> createState() => _ListMoviesState();
}

class _ListMoviesState extends State<ListMovies> {
  MoviesDatabase? db;

  @override
  void initState() {
    super.initState();
    db = MoviesDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de peliculas: "),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              "/add",
            ).then((value) => setState(() {})),
            icon: Icon(Icons.add_sharp),
          ),
        ],
      ),
      body: FutureBuilder(
        future: db!.SELECT(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong"));
          } else {
            if (snapshot.hasData) {
              return snapshot.data!.isNotEmpty
                  ? ListView.builder(
                      itemBuilder: (context, index) {
                        // data generated objetc
                        final obj = snapshot.data![index];
                        return Container(
                          height: 100,
                          color: Colors.black,
                          // child: Text(snapshot.data[index].nameMovie),
                          child: Text(obj.nameMovie!),
                        );
                      },
                    )
                  : Center(child: Text("no existen datos"));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
        },
      ),
    );
  }
}
