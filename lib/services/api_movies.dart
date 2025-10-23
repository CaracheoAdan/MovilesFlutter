import 'package:dio/dio.dart';
import 'package:movilesejmplo1/models/api_movie_dao.dart';
class ApiMovies {
 final dio = Dio();
 final URL = "https://api.themoviedb.org/3/movie/popular?api_key=5019e68de7bc112f4e4337a500b96c56&language=es-MX&page=1";

 Future<List<ApiMovieDao>> getMovies() async {
   final response = await dio.get(URL);
   final res = response.data['results'] as List;
   return res.map((movie) => ApiMovieDao.fromMap(movie)).toList();
   //response.data;
 }  
}