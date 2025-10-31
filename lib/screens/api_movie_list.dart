import 'package:flutter/material.dart';
import 'package:movilesejmplo1/widgets/movie_widget.dart';
import 'package:movilesejmplo1/models/api_movie_dao.dart';
import 'package:movilesejmplo1/services/api_movies.dart';

class ApiMoviesList extends StatefulWidget {
  const ApiMoviesList({super.key});

  @override
  State<ApiMoviesList> createState() => _ApiMoviesListState();
}

class _ApiMoviesListState extends State<ApiMoviesList> {
  late final ApiMoviesService _api;               // servicio unificado
  late Future<List<ApiMovieDao>> _futureMovies;   // future tipado

  @override
  void initState() {
    super.initState();
    _api = ApiMoviesService(
      apiKey: 'TU_API_KEY_AQUI', // pon aquí tu key (la que uses)
    );
    _futureMovies = _api.getPopular(page: 1, language: 'es-MX');
  }

  Future<void> _reload() async {
    setState(() {
      _futureMovies = _api.getPopular(page: 1, language: 'es-MX');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Movies')),
      body: FutureBuilder<List<ApiMovieDao>>(
        future: _futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 12),
                  FilledButton(onPressed: _reload, child: const Text('Reintentar')),
                ],
              ),
            );
          }

          final movies = snapshot.data ?? const <ApiMovieDao>[];
          if (movies.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('No hay películas.'),
                  const SizedBox(height: 12),
                  FilledButton(onPressed: _reload, child: const Text('Actualizar')),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2 / 3,
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return MovieWidget(movie: movies[index]);
            },
          );
        },
      ),
    );
  }
}
