import 'package:dio/dio.dart';
import 'package:movilesejmplo1/models/api_movie_dao.dart';

/// Servicio unificado para TMDb (popular movies)
class ApiMoviesService {
  // --- Config base ---
  static const String _defaultApiKey = '5019e68de7bc112f4e4337a500b96c56';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  final Dio _dio;
  final String _apiKey;

  ApiMoviesService({
    Dio? dio,
    String? apiKey, // Si quieres usar otra (p. ej. "0a905548d7e462e406c9a409d2e9ba7c")
  })  : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: _baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 20),
              ),
            ),
        _apiKey = apiKey ?? _defaultApiKey;

  /// Obtiene películas populares.
  /// Ejemplo: getPopular(page: 1, language: 'es-MX')
  Future<List<ApiMovieDao>> getPopular({
    int page = 1,
    String language = 'es-MX',
  }) async {
    try {
      final response = await _dio.get(
        '/movie/popular',
        queryParameters: {
          'api_key': _apiKey,
          'language': language,
          'page': page,
        },
      );

      final results = (response.data['results'] as List?) ?? const [];
      return results
          .map((e) => ApiMovieDao.fromMap(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      // Puedes loguear e.response?.data si lo necesitas
      rethrow;
    }
  }

  /// Helper para construir URL de pósters/backdrops.
  /// Ej: imageUrl(movie.posterPath) o imageUrl(movie.backdropPath, size: 'w780')
  static String imageUrl(String? path, {String size = 'w500'}) {
    if (path == null || path.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/$size$path';
  }
}
