class SauceDao {
  int? idSauce;
  String? name;
  int? extra; // 0 = gratis

  SauceDao({this.idSauce, this.name, this.extra});

  factory SauceDao.fromMap(Map<String, dynamic> m) => SauceDao(
        idSauce: m['idSauce'],
        name: m['name'],
        extra: m['extra'],
      );

  Map<String, dynamic> toMap() => {
        'idSauce': idSauce,
        'name': name,
        'extra': extra,
      };
}
