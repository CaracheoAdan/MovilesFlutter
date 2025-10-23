import 'package:flutter/material.dart';
import 'package:movilesejmplo1/database/food_database.dart';
import 'package:movilesejmplo1/models/product_dao.dart';
import 'package:movilesejmplo1/models/sauce_dao.dart';
import 'package:movilesejmplo1/models/drink_dao.dart';

class CartItemFormScreen extends StatefulWidget {
  const CartItemFormScreen({super.key});

  @override
  State<CartItemFormScreen> createState() => _CartItemFormScreenState();
}

class _CartItemFormScreenState extends State<CartItemFormScreen> {
  final db = FoodDatabase();
  final _form = GlobalKey<FormState>();

  List<ProductDao> _products = [];
  List<SauceDao> _sauces = [];
  List<DrinkDao> _drinks = [];

  ProductDao? _selectedProduct;
  SauceDao?   _selectedSauce; // opcional
  DrinkDao?   _selectedDrink; // opcional
  int _qty = 1;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await db.selectProducts();
    final s = await db.selectSauces();
    final d = await db.selectDrinks();
    setState(() {
      _products = p;
      _sauces   = s;
      _drinks   = d;
      if (p.isNotEmpty) _selectedProduct = p.first;
    });
  }

  String _money(int cents) => 'R${(cents / 100).toStringAsFixed(2)}';

  Future<void> _save() async {
    if (_selectedProduct == null) return;
    await db.cartAdd(
      idProduct: _selectedProduct!.idProduct!,
      qty: _qty,
      idSauce: _selectedSauce?.idSauce,
      idDrink: _selectedDrink?.idDrink,
    );
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Cart Item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: _products.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    // Producto
                    const Text('Product', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<ProductDao>(
                      value: _selectedProduct,
                      items: _products
                          .map((p) => DropdownMenuItem(
                                value: p,
                                child: Text('${p.name} · ${_money(p.price ?? 0)}'),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedProduct = v),
                    ),
                    const SizedBox(height: 16),

                    // Salsa (opcional)
                    const Text('Sauce (optional)', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<SauceDao>(
                      value: _selectedSauce,
                      items: [
                        const DropdownMenuItem<SauceDao>(
                          value: null,
                          child: Text('— None —'),
                        ),
                        ..._sauces.map((s) => DropdownMenuItem(
                              value: s,
                              child: Text('${s.name} · ${(s.extra ?? 0) == 0 ? "FREE" : "+${_money(s.extra ?? 0)}"}'),
                            )),
                      ],
                      onChanged: (v) => setState(() => _selectedSauce = v),
                    ),
                    const SizedBox(height: 16),

                    // Bebida (opcional)
                    const Text('Drink (optional)', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<DrinkDao>(
                      value: _selectedDrink,
                      items: [
                        const DropdownMenuItem<DrinkDao>(
                          value: null,
                          child: Text('— None —'),
                        ),
                        ..._drinks.map((d) => DropdownMenuItem(
                              value: d,
                              child: Text('${d.name} ${d.size ?? ""} · ${_money(d.price ?? 0)}'),
                            )),
                      ],
                      onChanged: (v) => setState(() => _selectedDrink = v),
                    ),
                    const SizedBox(height: 16),

                    // Cantidad
                    Row(
                      children: [
                        const Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        IconButton(
                          onPressed: () => setState(() => _qty = (_qty - 1).clamp(1, 99)),
                          icon: const Icon(Icons.remove),
                        ),
                        Text('$_qty', style: const TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          onPressed: () => setState(() => _qty = (_qty + 1).clamp(1, 99)),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    FilledButton(onPressed: _save, child: const Text('Add to Cart')),
                  ],
                ),
        ),
      ),
    );
  }
}
