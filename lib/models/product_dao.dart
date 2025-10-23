class ProductDao {
  int? idProduct;
  String? name;
  int? price;              // en centavos: 6200 = $62.00
  String? image;           // ruta o url
  String? description;

  ProductDao({this.idProduct, this.name, this.price, this.image, this.description});

  factory ProductDao.fromMap(Map<String, dynamic> m) => ProductDao(
        idProduct: m['idProduct'],
        name: m['name'],
        price: m['price'],
        image: m['image'],
        description: m['description'],
      );

  Map<String, dynamic> toMap() => {
        'idProduct': idProduct,
        'name': name,
        'price': price,
        'image': image,
        'description': description,
      };
}
