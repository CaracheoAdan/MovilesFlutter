import 'package:flutter/material.dart';
import 'package:movilesejmplo1/database/food_database.dart';
import 'package:movilesejmplo1/models/product_dao.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});
  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final db = FoodDatabase();
  final _form = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final imageCtrl = TextEditingController();
  final descCtrl  = TextEditingController();

  ProductDao? _editing;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is ProductDao && _editing == null) {
      _editing = args;
      nameCtrl.text  = args.name ?? '';
      priceCtrl.text = args.price == null ? '' : (args.price! / 100).toStringAsFixed(2);
      imageCtrl.text = args.image ?? '';
      descCtrl.text  = args.description ?? '';
    }
  }

  @override
  void dispose() { nameCtrl.dispose(); priceCtrl.dispose(); imageCtrl.dispose(); descCtrl.dispose(); super.dispose(); }

  String _moneyPreview() {
    final v = double.tryParse(priceCtrl.text.replaceAll(',', '.')) ?? 0;
    return 'R${v.toStringAsFixed(2)}';
    }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final cents = ((double.tryParse(priceCtrl.text.replaceAll(',', '.')) ?? 0) * 100).round();
    if (_editing == null) {
      await db.INSERT('tblProduct', {
        'name': nameCtrl.text.trim(),
        'price': cents,
        'image': imageCtrl.text.trim(),
        'description': descCtrl.text.trim(),
      });
    } else {
      await db.UPDATE('tblProduct', {
        'idProduct': _editing!.idProduct,
        'name': nameCtrl.text.trim(),
        'price': cents,
        'image': imageCtrl.text.trim(),
        'description': descCtrl.text.trim(),
      }, 'idProduct');
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Producto guardado')));
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = _editing != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Editar producto' : 'Nuevo producto')),
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
                      prefixIcon: Icon(Icons.fastfood),
                      filled: true,
                    ),
                    validator: (v) => (v==null||v.trim().isEmpty) ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: priceCtrl,
                    decoration: InputDecoration(
                      labelText: 'Precio (R)',
                      prefixIcon: const Icon(Icons.attach_money),
                      suffixText: _moneyPreview(),
                      filled: true,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (_) => setState(() {}),
                    validator: (v) => (double.tryParse((v??'').replaceAll(',', '.'))==null)
                        ? 'Número válido'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: imageCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Imagen (URL / asset)',
                      prefixIcon: Icon(Icons.image_outlined),
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      prefixIcon: Icon(Icons.notes),
                      filled: true,
                    ),
                    maxLines: 3,
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
