class CartItemDao {
  int? idCartItem;
  int? idProduct;
  int? qty;
  int? idSauce;   // opcional
  int? idDrink;   // opcional
  int? lineTotal; // precio calculado y guardado (en centavos)

  CartItemDao(
      {this.idCartItem, this.idProduct, this.qty, this.idSauce, this.idDrink, this.lineTotal});

  factory CartItemDao.fromMap(Map<String, dynamic> m) => CartItemDao(
        idCartItem: m['idCartItem'],
        idProduct: m['idProduct'],
        qty: m['qty'],
        idSauce: m['idSauce'],
        idDrink: m['idDrink'],
        lineTotal: m['lineTotal'],
      );

  Map<String, dynamic> toMap() => {
        'idCartItem': idCartItem,
        'idProduct': idProduct,
        'qty': qty,
        'idSauce': idSauce,
        'idDrink': idDrink,
        'lineTotal': lineTotal,
      };
}
