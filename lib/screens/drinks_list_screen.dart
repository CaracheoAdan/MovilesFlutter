import 'package:flutter/material.dart';
import 'package:movilesejmplo1/database/food_database.dart';
import 'package:movilesejmplo1/models/drink_dao.dart';

class DrinksListScreen extends StatefulWidget {
  const DrinksListScreen({super.key});
  @override
  State<DrinksListScreen> createState() => _DrinksListScreenState();
}

class _DrinksListScreenState extends State<DrinksListScreen> {
  final db = FoodDatabase();
  List<DrinkDao> items = [];
  bool loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final res = await db.selectDrinks();
    setState(() { items = res; loading = false; });
  }

  Future<void> _delete(DrinkDao m) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar bebida'),
        content: Text('${m.name ?? ''} ${m.size ?? ''}'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (ok != true) return;
    await db.DELETE_BY_ID('tblDrink', 'idDrink', m.idDrink!);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drinks')),
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
                      leading: const CircleAvatar(child: Icon(Icons.local_drink)),
                      title: Text(m.name ?? ''),
                      subtitle: Wrap(
                        spacing: 8,
                        children: [
                          Chip(label: Text(m.size ?? ''), visualDensity: VisualDensity.compact),
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
                              await Navigator.pushNamed(context, '/formDrink', arguments: m);
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
        onPressed: () async { await Navigator.pushNamed(context, '/formDrink'); await _load(); },
        child: const Icon(Icons.add),
      ),
    );
  }
}
