import 'package:flutter/material.dart';
import 'package:movilesejmplo1/database/food_database.dart';
import 'package:movilesejmplo1/models/cart_item_dao.dart';
import 'package:movilesejmplo1/models/product_dao.dart';
import 'package:movilesejmplo1/models/sauce_dao.dart';
import 'package:movilesejmplo1/models/drink_dao.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final db = FoodDatabase();
  List<CartItemDao> _items = [];
  Map<int, ProductDao> _products = {};
  Map<int, SauceDao> _sauces = {};
  Map<int, DrinkDao> _drinks = {};
  bool _loading = true;

  String _money(int cents) => 'R${(cents / 100).toStringAsFixed(2)}';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items  = await db.selectCart();
    final prods  = await db.selectProducts();
    final sauces = await db.selectSauces();
    final drinks = await db.selectDrinks();
    if (!mounted) return;
    setState(() {
      _items = items;
      _products = {for (final p in prods) p.idProduct!: p};
      _sauces   = {for (final s in sauces) s.idSauce!: s};
      _drinks   = {for (final d in drinks) d.idDrink!: d};
      _loading = false;
    });
  }

  int get _total => _items.fold(0, (s, e) => s + (e.lineTotal ?? 0));

  Future<void> _changeQty(CartItemDao row, int delta) async {
    final newQty = ((row.qty ?? 1) + delta).clamp(1, 99);
    await db.cartUpdateQty(row.idCartItem!, newQty);
    await _load();
  }

  Future<void> _remove(CartItemDao row) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar del carrito'),
        content: const Text('¿Seguro que quieres eliminar este artículo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (ok == true) {
      await db.cartRemove(row.idCartItem!);
      await _load();
    }
  }

  Future<void> _placeOrder() async {
    if (_items.isEmpty) return;
    final id = await db.createOrderFromCart();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pedido #$id creado por ${_money(_total)}')),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tu carrito'),
        actions: [
          if (_items.isNotEmpty)
            TextButton(
              onPressed: () async { await db.cartClear(); await _load(); },
              child: const Text('Vaciar', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(child: Text('Tu carrito está vacío'))
              : Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _load,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (_, i) {
                            final row = _items[i];
                            final p = _products[row.idProduct]!;
                            final s = row.idSauce != null ? _sauces[row.idSauce!] : null;
                            final d = row.idDrink != null ? _drinks[row.idDrink!] : null;

                            return Card(
                              elevation: 1.5,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 26,
                                      child: Text((p.name ?? 'P').substring(0,1).toUpperCase()),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(p.name ?? 'Product',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700, fontSize: 16)),
                                          const SizedBox(height: 4),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: -6,
                                            children: [
                                              if (s != null)
                                                Chip(label: Text('Sauce: ${s.name}'),
                                                     visualDensity: VisualDensity.compact),
                                              if (d != null)
                                                Chip(label: Text('Drink: ${d.name} ${d.size ?? ''}'),
                                                     visualDensity: VisualDensity.compact),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text('Línea: ${_money(row.lineTotal ?? 0)}',
                                              style: const TextStyle(fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed: () => _changeQty(row, -1),
                                              icon: const Icon(Icons.remove_circle_outline),
                                            ),
                                            Text('${row.qty ?? 1}',
                                                style: const TextStyle(fontWeight: FontWeight.bold)),
                                            IconButton(
                                              onPressed: () => _changeQty(row, 1),
                                              icon: const Icon(Icons.add_circle_outline),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          onPressed: () => _remove(row),
                                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10, offset: const Offset(0, -2))],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Total', style: TextStyle(fontWeight: FontWeight.w600)),
                                Text(_money(_total),
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                              ],
                            ),
                          ),
                          FilledButton.icon(
                            onPressed: _placeOrder,
                            icon: const Icon(Icons.payment),
                            label: const Text('Finalizar pedido'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
