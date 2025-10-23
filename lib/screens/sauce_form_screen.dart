import 'package:flutter/material.dart';
import 'package:movilesejmplo1/database/food_database.dart';
import 'package:movilesejmplo1/models/sauce_dao.dart';

class SauceFormScreen extends StatefulWidget {
  const SauceFormScreen({super.key});
  @override
  State<SauceFormScreen> createState() => _SauceFormScreenState();
}

class _SauceFormScreenState extends State<SauceFormScreen> {
  final db = FoodDatabase();
  final _form = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final extraCtrl = TextEditingController();

  SauceDao? _editing;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is SauceDao && _editing == null) {
      _editing = args;
      nameCtrl.text  = args.name ?? '';
      extraCtrl.text = args.extra == null ? '' : (args.extra! / 100).toStringAsFixed(2);
    }
  }

  @override
  void dispose() { nameCtrl.dispose(); extraCtrl.dispose(); super.dispose(); }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final cents = ((double.tryParse(extraCtrl.text.replaceAll(',', '.')) ?? 0) * 100).round();
    if (_editing == null) {
      await db.INSERT('tblSauce', { 'name': nameCtrl.text.trim(), 'extra': cents });
    } else {
      await db.UPDATE('tblSauce', {
        'idSauce': _editing!.idSauce,
        'name': nameCtrl.text.trim(),
        'extra': cents,
      }, 'idSauce');
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Salsa guardada')));
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = _editing != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar salsa' : 'Nueva salsa')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      prefixIcon: Icon(Icons.local_fire_department),
                      filled: true,
                    ),
                    validator: (v) => (v==null||v.trim().isEmpty) ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: extraCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Extra (R, 0 = FREE)',
                      prefixIcon: Icon(Icons.add_circle_outline),
                      filled: true,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
