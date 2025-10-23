class OrderDao {
  final int? idOrder;
  final int? total;        // centavos
  final String? createdAt; // "yyyy-MM-dd HH:mm:ss"

  OrderDao({this.idOrder, this.total, this.createdAt});

  factory OrderDao.fromMap(Map<String, dynamic> m) => OrderDao(
        idOrder: m['idOrder'] as int?,
        total: m['total'] as int?,
        createdAt: m['createdAt'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'idOrder': idOrder,
        'total': total,
        'createdAt': createdAt,
      };
}
