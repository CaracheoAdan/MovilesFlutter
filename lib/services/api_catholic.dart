import 'package:dio/dio.dart';
import 'package:movilesejmplo1/models/series_dao.dart';
import 'package:movilesejmplo1/utils/app_strings.dart';
import 'package:async/async.dart';

class ApiCatholic {
  Dio dio = Dio();

  Future<List<SeriesDao>> getCategory(int idCategory) async {
    String url = "${AppStrings.url_base}/json/categories/$idCategory.json";
    final response = await dio.get(url);
    final res = response.data['series'] as List;

    return res.map((serie) => SeriesDao.fromMap(serie)).toList();
  }

  Future<List<SeriesDao>> getAllCategories() async {
    final FutureGroup<List<SeriesDao>> futureGroup =
        FutureGroup<List<SeriesDao>>();

    futureGroup.add(getCategory(2));
    futureGroup.add(getCategory(3));
    futureGroup.add(getCategory(4));
    futureGroup.add(getCategory(5));
    futureGroup.add(getCategory(6));
    futureGroup.close();

    List<SeriesDao> listSeries = List<SeriesDao>.empty(growable: true);
    final List<List<SeriesDao>> results = await futureGroup.future;

    for (var result in results) {
      listSeries.addAll(result);
    }

    return listSeries;
  }
}
