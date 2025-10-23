import 'package:flutter/material.dart';
import 'package:movilesejmplo1/database/food_database.dart';
import 'package:movilesejmplo1/models/drink_dao.dart';

class DrinkFormScreen extends StatefulWidget {
  const DrinkFormScreen({super.key});
  @override
  State<DrinkFormScreen> createState() => _DrinkFormScreenState();
}

class _DrinkFormScreenState extends State<DrinkFormScreen> {
  final db = FoodDatabase();
  final _form = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final sizeCtrl = TextEditingController(text: '330ml');
  final priceCtrl = TextEditingController();

  DrinkDao? _editing;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is DrinkDao && _editing == null) {
      _editing = args;
      nameCtrl.text  = args.name ?? '';
      sizeCtrl.text  = args.size ?? '330ml';
      priceCtrl.text = args.price == null ? '' : (args.price! / 100).toStringAsFixed(2);
    }
  }

  @override
  void dispose() { nameCtrl.dispose(); sizeCtrl.dispose(); priceCtrl.dispose(); super.dispose(); }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final cents = ((double.tryParse(priceCtrl.text.replaceAll(',', '.')) ?? 0) * 100).round();
    if (_editing == null) {
      await db.INSERT('tblDrink', {
        'name': nameCtrl.text.trim(),
        'size': sizeCtrl.text.trim(),
        'price': cents,
      });
    } else {
      await db.UPDATE('tblDrink', {
        'idDrink': _editing!.idDrink,
        'name': nameCtrl.text.trim(),
        'size': sizeCtrl.text.trim(),
        'price': cents,
      }, 'idDrink');
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bebida guardada')));
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = _editing != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar bebida' : 'Nueva bebida')),
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
                      prefixIcon: Icon(Icons.local_drink),
                      filled: true,
                    ),
                    validator: (v) => (v==null||v.trim().isEmpty) ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: sizeCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Tamaño (ej. 330ml)',
                      prefixIcon: Icon(Icons.straighten),
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: priceCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Precio (R)',
                      prefixIcon: Icon(Icons.attach_money),
                      filled: true,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) => (double.tryParse((v??'').replaceAll(',', '.'))==null)
                        ? 'Número válido'
                        : null,
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
