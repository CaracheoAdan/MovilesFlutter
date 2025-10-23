import 'package:flutter/material.dart';
import 'package:movilesejmplo1/database/food_database.dart';
import 'package:movilesejmplo1/models/sauce_dao.dart';

class SaucesListScreen extends StatefulWidget {
  const SaucesListScreen({super.key});
  @override
  State<SaucesListScreen> createState() => _SaucesListScreenState();
}

class _SaucesListScreenState extends State<SaucesListScreen> {
  final db = FoodDatabase();
  List<SauceDao> items = [];
  bool loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final res = await db.selectSauces();
    setState(() { items = res; loading = false; });
  }

  Future<void> _delete(SauceDao m) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar salsa'),
        content: Text(m.name ?? ''),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (ok != true) return;
    await db.DELETE_BY_ID('tblSauce', 'idSauce', m.idSauce!);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sauces')),
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
                  final label = (m.extra ?? 0) == 0 ? 'FREE' : '+R${((m.extra ?? 0)/100).toStringAsFixed(2)}';
                  return Card(
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.local_fire_department)),
                      title: Text(m.name ?? ''),
                      subtitle: Chip(label: Text(label), visualDensity: VisualDensity.compact),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Editar',
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              await Navigator.pushNamed(context, '/formSauce', arguments: m);
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
        onPressed: () async { await Navigator.pushNamed(context, '/formSauce'); await _load(); },
        child: const Icon(Icons.add),
      ),
    );
  }
}
