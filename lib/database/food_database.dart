import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:movilesejmplo1/models/product_dao.dart';
import 'package:movilesejmplo1/models/sauce_dao.dart';
import 'package:movilesejmplo1/models/drink_dao.dart';
import 'package:movilesejmplo1/models/cart_item_dao.dart';
import 'package:movilesejmplo1/models/order_dao.dart';

class FoodDatabase {
  static const nameDB = 'FOODDB';
  static const versionDB = 1;

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    return _database = await _initDatabase();
  }

  Future<Database?> _initDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    final pathDB = join(folder.path, nameDB);
    return openDatabase(
      pathDB,
      version: versionDB,
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    // Productos base
    await db.execute('''
      CREATE TABLE tblProduct(
        idProduct INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(60),
        price INTEGER,
        image TEXT,
        description TEXT
      )
    ''');
    // Salsas
    await db.execute('''
      CREATE TABLE tblSauce(
        idSauce INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(40),
        extra INTEGER
      )
    ''');
    // Bebidas
    await db.execute('''
      CREATE TABLE tblDrink(
        idDrink INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(60),
        size VARCHAR(20),
        price INTEGER
      )
    ''');
    // Carrito
    await db.execute('''
      CREATE TABLE tblCartItem(
        idCartItem INTEGER PRIMARY KEY AUTOINCREMENT,
        idProduct INTEGER REFERENCES tblProduct(idProduct),
        qty INTEGER,
        idSauce INTEGER NULL REFERENCES tblSauce(idSauce),
        idDrink INTEGER NULL REFERENCES tblDrink(idDrink),
        lineTotal INTEGER
      )
    ''');
    // Pedido
    await db.execute('''
      CREATE TABLE tblOrder(
        idOrder INTEGER PRIMARY KEY AUTOINCREMENT,
        total INTEGER,
        createdAt CHAR(19)
      )
    ''');
    await db.execute('''
      CREATE TABLE tblOrderItem(
        idOrderItem INTEGER PRIMARY KEY AUTOINCREMENT,
        idOrder INTEGER REFERENCES tblOrder(idOrder),
        idProduct INTEGER,
        qty INTEGER,
        idSauce INTEGER NULL,
        idDrink INTEGER NULL,
        lineTotal INTEGER
      )
    ''');

    await db.insert('tblProduct', {
      'name': 'Kota Clásica',
      'price': 6200,
      'image': 'assets/kota_classic.png',
      'description': 'Pan con papas, queso, vienas y salsa.'
    });
    await db.insert('tblProduct', {
      'name': 'Kota Pollo',
      'price': 7200,
      'image': 'assets/kota_chicken.png',
      'description': 'Pollo crispy, queso y papas.'
    });

    await db.insert('tblSauce', {'name': 'Tomato Sauce', 'extra': 0});
    await db.insert('tblSauce', {'name': 'BBQ Sauce', 'extra': 400});
    await db.insert('tblSauce', {'name': 'Chakalaka sauce', 'extra': 200});

    await db.insert('tblDrink', {'name': 'Coca-Cola', 'size': '330ml', 'price': 1800});
    await db.insert('tblDrink', {'name': 'Sprite', 'size': '330ml', 'price': 1800});
  }

  Future<int> INSERT(String table, Map<String, dynamic> data) async {
    final con = await database;
    return con!.insert(table, data);
  }

  Future<int> UPDATE(String table, Map<String, dynamic> data, String keyColumn) async {
    final con = await database;
    return con!.update(table, data, where: '$keyColumn = ?', whereArgs: [data[keyColumn]]);
  }

  Future<int> DELETE_BY_ID(String table, String keyColumn, int id) async {
    final con = await database;
    return con!.delete(table, where: '$keyColumn = ?', whereArgs: [id]);
  }


  Future<List<ProductDao>> selectProducts() async {
    final con = await database;
    final res = await con!.query('tblProduct', orderBy: 'idProduct');
    return res.map((m) => ProductDao.fromMap(m)).toList();
  }

  Future<List<SauceDao>> selectSauces() async {
    final con = await database;
    final res = await con!.query('tblSauce', orderBy: 'idSauce');
    return res.map((m) => SauceDao.fromMap(m)).toList();
  }

  Future<List<DrinkDao>> selectDrinks() async {
    final con = await database;
    final res = await con!.query('tblDrink', orderBy: 'idDrink');
    return res.map((m) => DrinkDao.fromMap(m)).toList();
  }

  // Carrito
  Future<List<CartItemDao>> selectCart() async {
    final con = await database;
    final res = await con!.query('tblCartItem', orderBy: 'idCartItem');
    return res.map((m) => CartItemDao.fromMap(m)).toList();
  }

  Future<int> cartAdd({
    required int idProduct,
    required int qty,
    int? idSauce,
    int? idDrink,
  }) async {
    final con = await database;

    final p = (await con!.query('tblProduct',
        columns: ['price'], where: 'idProduct=?', whereArgs: [idProduct])).first['price'] as int;

    int extra = 0;
    if (idSauce != null) {
      final s = (await con.query('tblSauce',
          columns: ['extra'], where: 'idSauce=?', whereArgs: [idSauce])).first['extra'] as int;
      extra += s;
    }
    if (idDrink != null) {
      final d = (await con.query('tblDrink',
          columns: ['price'], where: 'idDrink=?', whereArgs: [idDrink])).first['price'] as int;
      extra += d;
    }

    final lineTotal = (p + extra) * qty;

    return con.insert('tblCartItem', {
      'idProduct': idProduct,
      'qty': qty,
      'idSauce': idSauce,
      'idDrink': idDrink,
      'lineTotal': lineTotal,
    });
  }

  Future<int> cartUpdateQty(int idCartItem, int newQty) async {
    final con = await database;

    final row = (await con!.query('tblCartItem', where: 'idCartItem=?', whereArgs: [idCartItem])).first;
    final idProduct = row['idProduct'] as int;
    final idSauce = row['idSauce'] as int?;
    final idDrink = row['idDrink'] as int?;

    final p = (await con.query('tblProduct',
        columns: ['price'], where: 'idProduct=?', whereArgs: [idProduct])).first['price'] as int;

    int extra = 0;
    if (idSauce != null) {
      extra += (await con.query('tblSauce',
          columns: ['extra'], where: 'idSauce=?', whereArgs: [idSauce])).first['extra'] as int;
    }
    if (idDrink != null) {
      extra += (await con.query('tblDrink',
          columns: ['price'], where: 'idDrink=?', whereArgs: [idDrink])).first['price'] as int;
    }

    final newLineTotal = (p + extra) * newQty;

    return con.update(
      'tblCartItem',
      {'qty': newQty, 'lineTotal': newLineTotal},
      where: 'idCartItem=?',
      whereArgs: [idCartItem],
    );
  }

  Future<int> cartRemove(int idCartItem) =>
      DELETE_BY_ID('tblCartItem', 'idCartItem', idCartItem);

  Future<int> cartClear() async {
    final con = await database;
    return con!.delete('tblCartItem');
  }

  Future<int> createOrderFromCart() async {
    final con = await database;
    return await con!.transaction<int>((txn) async {
      final rows = await txn.query('tblCartItem');
      if (rows.isEmpty) return 0;

      final total = rows.fold<int>(0, (sum, r) => sum + (r['lineTotal'] as int));
      final now = DateTime.now();
      final createdAt =
          '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

      final idOrder = await txn.insert('tblOrder', {'total': total, 'createdAt': createdAt});

      for (final r in rows) {
        await txn.insert('tblOrderItem', {
          'idOrder': idOrder,
          'idProduct': r['idProduct'],
          'qty': r['qty'],
          'idSauce': r['idSauce'],
          'idDrink': r['idDrink'],
          'lineTotal': r['lineTotal'],
        });
      }
      await txn.delete('tblCartItem');
      return idOrder;
    });
  }

  Future<List<OrderDao>> selectOrders() async {
    final con = await database;
    final res = await con!.query('tblOrder', orderBy: 'idOrder DESC');
    return res.map((m) => OrderDao.fromMap(m)).toList();
  }
}
