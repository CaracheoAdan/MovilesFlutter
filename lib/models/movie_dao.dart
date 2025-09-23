class MovieDao {
  int? idMovie;
  String? nameMovie;
  String? time;
  String? dataRelease;

  MovieDao({this.idMovie, this.nameMovie, this.time, this.dateRealease});

  factory MovieDao.fromMap(Map<String, dynamic>){
    return MovieDao(
      idMovie: mapa['idMovie'], 
      nameMovie: mapa['nameMovie'],
      time: mapa['time'],
      dateRealease: mapa['dataRelease']);
  }
}