import 'package:flutter/material.dart';
import 'package:movilesejmplo1/models/api_movie_dao.dart';

class MovieWidget extends StatelessWidget {
  const MovieWidget({super.key, required this.movie});

  final ApiMovieDao movie;

  @override
  Widget build(BuildContext context) {
    final posterPath = movie.posterPath ?? '';
    final posterUrl = posterPath.isEmpty
        ? null
        : 'https://image.tmdb.org/t/p/w500$posterPath';

    return SizedBox(
      height: 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AspectRatio(
          aspectRatio: 2 / 3, // típico póster
          child: posterUrl == null
              ? Container(
                  color: Colors.black12,
                  child: const Center(
                    child: Icon(Icons.movie, size: 48),
                  ),
                )
              : FadeInImage.assetNetwork(
                  placeholder: 'assets/loading.gif', // asegúrate en pubspec.yaml
                  image: posterUrl,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stack) => Container(
                    color: Colors.black12,
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 48),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
