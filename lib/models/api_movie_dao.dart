import 'package:flutter/services.dart';

class ApiMovieDao {
  String backdropPath;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  DateTime releaseDate;
  String title;
  double voteAverage;
  int voteCount;

  ApiMovieDao({
    required this.backdropPath,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });
  factory ApiMovieDao.fromMap(Map<String, dynamic> map) {
    return ApiMovieDao(
      backdropPath: map['backdrop_path'] ?? '',
      id: map['id']?.toInt() ?? 0,
      originalLanguage: map['original_language'] ?? '',
      originalTitle: map['original_title'] ?? '',
      overview: map['overview'] ?? '',
      popularity: (map['popularity']?.toDouble() ?? 0.0),
      posterPath: map['poster_path'] ?? '',
      releaseDate: DateTime.tryParse(map['release_date'] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      title: map['title'] ?? '',
      voteAverage: (map['vote_average']?.toDouble() ?? 0.0),
      voteCount: map['vote_count']?.toInt() ?? 0,
    );
  }
}
