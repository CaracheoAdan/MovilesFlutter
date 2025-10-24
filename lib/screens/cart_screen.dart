import 'package:flutter/material.dart';
import 'package:movilesejmplo1/database/food_database.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final db = FoodDatabase();

  final Color _brand = const Color(0xFFFFB000);
  final Color _ink = const Color(0xFF0F172A);
  final Color _inkSoft = const Color(0xFF475569);

  bool _loading = true;
  int _total = 0;

  List<Map<String, dynamic>> _items = [];

  String _money(int cents) => 'R${(cents / 100).toStringAsFixed(2)}';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final con = await db.database;
    final rows = await con!.rawQuery('''
      SELECT
        c.idCartItem,
        c.qty,
        c.lineTotal,
        p.name AS productName,
        s.name AS sauceName,
        d.name AS drinkName,
        d.size AS drinkSize
      FROM tblCartItem c
      LEFT JOIN tblProduct p ON p.idProduct = c.idProduct
      LEFT JOIN tblSauce   s ON s.idSauce   = c.idSauce
      LEFT JOIN tblDrink   d ON d.idDrink   = c.idDrink
      ORDER BY c.idCartItem DESC
    ''');

    final tot = rows.fold<int>(0, (sum, r) => sum + ((r['lineTotal'] as int?) ?? 0));

    if (!mounted) return;
    setState(() {
      _items = rows.map((e) => Map<String, dynamic>.from(e)).toList();
      _total = tot;
      _loading = false;
    });
  }

  Future<void> _removeItem(int idCartItem) async {
    await db.DELETE_BY_ID('tblCartItem', 'idCartItem', idCartItem);
    await _load();
  }

  Future<void> _clear() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Vaciar carrito'),
        content: const Text('¿Seguro que quieres vaciar el carrito?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Vaciar')),
        ],
      ),
    );
    if (ok == true) {
      await db.cartClear();
      await _load();
    }
  }

  Future<void> _checkout() async {
    if (_items.isEmpty) return;
    final idOrder = await db.createOrderFromCart();
    if (!mounted) return;
    if (idOrder > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pedido #$idOrder creado')),
      );
      await _load();
    }
  }

  // Chip claro reutilizable (evita los cuadros negros)
  Widget _lightChip(String text) => Chip(
        label: Text(text, style: TextStyle(color: _ink)),
        backgroundColor: Colors.white,
        side: BorderSide(color: _inkSoft.withOpacity(.2)),
        shape: const StadiumBorder(),
        visualDensity: VisualDensity.compact,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _brand,
      appBar: AppBar(
        backgroundColor: _brand,
        elevation: 0,
        foregroundColor: _ink,
        title: Text('Tu carrito', style: TextStyle(color: _ink, fontWeight: FontWeight.w800)),
        actions: [
          TextButton(
            onPressed: _items.isEmpty ? null : _clear,
            child: const Text('Vaciar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              children: [
                Expanded(
                  child: _items.isEmpty
                      ? Center(
                          child: Text('No hay artículos en el carrito',
                              style: TextStyle(color: _ink, fontWeight: FontWeight.w700)),
                        )
                      : ListView.separated(
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final it = _items[i];
                            final idCartItem = (it['idCartItem'] as int?) ?? -1;
                            final qty = (it['qty'] as int?) ?? 1;
                            final lineTotal = (it['lineTotal'] as int?) ?? 0;
                            final product = (it['productName'] as String?) ?? 'Producto';
                            final sauce = it['sauceName'] as String?;
                            final drink = it['drinkName'] as String?;
                            final size = it['drinkSize'] as String?;

                            return ListTile(
                              isThreeLine: true, // <-- da más alto para evitar overflow
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              title: Text(product, style: TextStyle(color: _ink, fontWeight: FontWeight.w800)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Cantidad: $qty', style: TextStyle(color: _inkSoft)),
                                  const SizedBox(height: 6),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: -6,
                                    children: [
                                      if (sauce != null && sauce.isNotEmpty) _lightChip('Salsa: $sauce'),
                                      if (drink != null && drink.isNotEmpty) _lightChip('Bebida: $drink ${size ?? ''}'),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(_money(lineTotal),
                                      style: TextStyle(color: _ink, fontWeight: FontWeight.w900)),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => _removeItem(idCartItem),
                                    tooltip: 'Eliminar',
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),

                // Footer total + checkout
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 10, offset: const Offset(0, -4))],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total', style: TextStyle(color: _inkSoft, fontWeight: FontWeight.w700)),
                            Text(_money(_total),
                                style: TextStyle(color: _ink, fontWeight: FontWeight.w900, fontSize: 20)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _ink,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: _items.isEmpty ? null : _checkout,
                          icon: const Icon(Icons.receipt_long),
                          label: const Text('Finalizar pedido'),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
