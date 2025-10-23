import 'package:flutter/material.dart';
import 'package:movilesejmplo1/database/food_database.dart';
import 'package:movilesejmplo1/models/product_dao.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  final db = FoodDatabase();
  List<ProductDao> items = [];
  bool loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final res = await db.selectProducts();
    setState(() { items = res; loading = false; });
  }

  Future<void> _delete(ProductDao m) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text(m.name ?? ''),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (ok != true) return;
    await db.DELETE_BY_ID('tblProduct', 'idProduct', m.idProduct!);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final m = items[i];
                  return Card(
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      leading: CircleAvatar(child: Text(m.name?.substring(0,1).toUpperCase() ?? 'P')),
                      title: Text(m.name ?? ''),
                      subtitle: Wrap(
                        spacing: 8,
                        children: [
                          Chip(label: Text('R${((m.price ?? 0)/100).toStringAsFixed(2)}'),
                               visualDensity: VisualDensity.compact),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Editar',
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              await Navigator.pushNamed(context, '/formProduct', arguments: m);
                              await _load();
                            },
                          ),
                          IconButton(
                            tooltip: 'Eliminar',
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _delete(m),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async { await Navigator.pushNamed(context, '/formProduct'); await _load(); },
        child: const Icon(Icons.add),
      ),
    );
  }
}
