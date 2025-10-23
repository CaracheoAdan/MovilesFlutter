class DrinkDao {
  int? idDrink;
  String? name;
  String? size; // ej. "330ml", "500ml"
  int? price;

  DrinkDao({this.idDrink, this.name, this.size, this.price});

  factory DrinkDao.fromMap(Map<String, dynamic> m) => DrinkDao(
        idDrink: m['idDrink'],
        name: m['name'],
        size: m['size'],
        price: m['price'],
      );

  Map<String, dynamic> toMap() => {
        'idDrink': idDrink,
        'name': name,
        'size': size,
        'price': price,
      };
}
