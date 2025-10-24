import 'package:flutter/material.dart';
import 'package:movilesejmplo1/database/food_database.dart';
import 'package:movilesejmplo1/models/product_dao.dart';
import 'package:movilesejmplo1/models/sauce_dao.dart';
import 'package:movilesejmplo1/models/drink_dao.dart';

class PlayfigmaScreen extends StatefulWidget {
  const PlayfigmaScreen({super.key});
  @override
  State<PlayfigmaScreen> createState() => _PlayfigmaScreenState();
}

class _PlayfigmaScreenState extends State<PlayfigmaScreen> {
  final db = FoodDatabase();

  // Paleta
  final Color _brand = const Color(0xFF2563EB);     // azul
  final Color _pageBg = const Color(0xFFF7F7F9);    // gris muy claro
  final Color _ink = const Color(0xFF0F172A);       // texto oscuro
  final Color _inkSoft = const Color(0xFF475569);   // texto gris
  final Color _header = const Color(0xFF0B1220);    // header oscuro
  final Color _headerBtn = const Color(0xFF1B2230); // botón en header

  ProductDao? _product;
  List<SauceDao> _sauces = [];
  List<DrinkDao> _drinks = [];
  int _selectedSauce = -1; // -1 = ninguna
  DrinkDao? _selectedDrink;
  int _qty = 1;
  bool _loading = true;

  int _cartCount = 0;

  String _money(int cents) => 'R${(cents / 100).toStringAsFixed(2)}';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loading) _load();
  }

  Future<void> _load() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final id = args?['idProduct'] as int?;

    final products = await db.selectProducts();
    final sauces   = await db.selectSauces();
    final drinks   = await db.selectDrinks();

    ProductDao? p;
    if (id != null) {
      p = products.firstWhere((e) => e.idProduct == id, orElse: () => ProductDao());
    } else {
      p = products.isNotEmpty ? products.first : null;
    }

    final cartItems = await db.selectCart();
    if (!mounted) return;
    setState(() {
      _product = p;
      _sauces = sauces;
      _drinks = drinks;
      _selectedSauce = -1;
      _selectedDrink = null;
      _qty = 1;
      _cartCount = cartItems.fold<int>(0, (s, e) => s + (e.qty ?? 0));
      _loading = false;
    });
  }

  Future<void> _addToCart() async {
    if (_product?.idProduct == null) return;
    final idSauce = _selectedSauce >= 0 ? _sauces[_selectedSauce].idSauce : null;
    final idDrink = _selectedDrink?.idDrink;
    await db.cartAdd(
      idProduct: _product!.idProduct!,
      qty: _qty,
      idSauce: idSauce,
      idDrink: idDrink,
    );
    if (!mounted) return;
    setState(() => _cartCount += _qty);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Agregado: ${_product!.name} x$_qty')),
    );
  }

  ImageProvider _imageFor(ProductDao? p) {
    final img = p?.image ?? '';
    if (img.startsWith('http')) return NetworkImage(img);
    if (img.isNotEmpty) return AssetImage(img);
    return const NetworkImage('https://picsum.photos/seed/product/400/300');
  }

  int get _selectedSauceExtra => _selectedSauce >= 0 ? (_sauces[_selectedSauce].extra ?? 0) : 0;
  int get _selectedDrinkPrice => _selectedDrink?.price ?? 0;
  int get _basePrice => _product?.price ?? 0;
  int get _lineTotal => (_basePrice + _selectedSauceExtra + _selectedDrinkPrice) * _qty;

  // Chip consistente para salsa/bebida
  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : _ink,
          fontWeight: FontWeight.w700,
        ),
      ),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      backgroundColor: Colors.white,
      selectedColor: _brand,
      side: BorderSide(
        color: selected ? _brand : _inkSoft.withOpacity(.25),
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      shape: const StadiumBorder(),
    );
  }

  // Botón “redondo” del header
  Widget _headerIcon(IconData icon, VoidCallback onTap) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: _headerBtn,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onTap,
        tooltip: '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _brand,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : Padding(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    color: _pageBg,
                    child: Column(
                      children: [
                        // Header
                        Container(
                          height: 86,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: _header,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(26),
                              bottomRight: Radius.circular(26),
                            ),
                          ),
                          child: Row(
                            children: [
                              _headerIcon(Icons.arrow_back, () => Navigator.maybePop(context)),
                              const SizedBox(width: 10),

                              // **** BOTÓN CALENDARIO (visible y con mismo estilo) ****
                              _headerIcon(
                                Icons.calendar_month,
                                () => Navigator.pushNamed(context, '/ordersCalendar'),
                              ),
                              const SizedBox(width: 14),

                              const Icon(Icons.storefront, color: Colors.white, size: 22),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _product?.name ?? 'Producto',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                  ),
                                ),
                              ),

                              // Carrito
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                                    onPressed: () async {
                                      await Navigator.pushNamed(context, '/cart');
                                      final items = await db.selectCart();
                                      if (!mounted) return;
                                      setState(() => _cartCount = items.fold<int>(0, (s, e) => s + (e.qty ?? 0)));
                                    },
                                  ),
                                  if (_cartCount > 0)
                                    Positioned(
                                      right: 2,
                                      top: 2,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '$_cartCount',
                                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            children: [
                              // Imagen
                              AspectRatio(
                                aspectRatio: 1.4,
                                child: Center(
                                  child: Image(image: _imageFor(_product), fit: BoxFit.contain),
                                ),
                              ),
                              const SizedBox(height: 10),

                              Text(
                                _product?.description?.trim().isNotEmpty == true
                                    ? _product!.description!
                                    : 'Sin descripción',
                                style: TextStyle(color: _ink, fontSize: 14, height: 1.3),
                              ),
                              const SizedBox(height: 8),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Precio base', style: TextStyle(color: _inkSoft, fontWeight: FontWeight.w700)),
                                  Text(_money(_basePrice), style: TextStyle(color: _ink, fontWeight: FontWeight.w900)),
                                ],
                              ),
                              const SizedBox(height: 16),

                              Text('Salsa', style: TextStyle(color: _ink, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: -6,
                                children: [
                                  _chip(
                                    label: 'Ninguna',
                                    selected: _selectedSauce == -1,
                                    onTap: () => setState(() => _selectedSauce = -1),
                                  ),
                                  ...List.generate(_sauces.length, (i) {
                                    final s = _sauces[i];
                                    final label = (s.extra ?? 0) == 0
                                        ? (s.name ?? 'Sauce')
                                        : '${s.name} (+${_money(s.extra ?? 0)})';
                                    return _chip(
                                      label: label,
                                      selected: _selectedSauce == i,
                                      onTap: () => setState(() => _selectedSauce = i),
                                    );
                                  }),
                                ],
                              ),
                              const SizedBox(height: 16),

                              Text('Bebida', style: TextStyle(color: _ink, fontWeight: FontWeight.w800)),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: -6,
                                children: [
                                  _chip(
                                    label: 'Ninguna',
                                    selected: _selectedDrink == null,
                                    onTap: () => setState(() => _selectedDrink = null),
                                  ),
                                  ..._drinks.map((d) {
                                    final lbl = '${d.name ?? ''} ${d.size ?? ''} (+${_money(d.price ?? 0)})';
                                    final sel = _selectedDrink?.idDrink == d.idDrink;
                                    return _chip(
                                      label: lbl,
                                      selected: sel,
                                      onTap: () => setState(() => _selectedDrink = d),
                                    );
                                  }),
                                ],
                              ),
                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 8, offset: const Offset(0, 4))],
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => setState(() => _qty = (_qty - 1).clamp(1, 99).toInt()),
                                          icon: const Icon(Icons.remove),
                                        ),
                                        Text('$_qty', style: TextStyle(color: _ink, fontSize: 16, fontWeight: FontWeight.w800)),
                                        IconButton(
                                          onPressed: () => setState(() => _qty = (_qty + 1).clamp(1, 99).toInt()),
                                          icon: const Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('Total', style: TextStyle(color: _inkSoft, fontWeight: FontWeight.w700)),
                                      Text(_money(_lineTotal),
                                          style: TextStyle(color: _ink, fontWeight: FontWeight.w900, fontSize: 18)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _brand,
                                    shape: const StadiumBorder(),
                                    elevation: 0,
                                  ),
                                  onPressed: _addToCart,
                                  icon: const Icon(Icons.add_shopping_cart),
                                  label: const Text('Agregar al carrito',
                                      style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton.icon(
                                onPressed: () => Navigator.pushNamed(context, '/Playfigmadetails'),
                                icon: Icon(Icons.grid_view_rounded, color: _inkSoft),
                                label: Text('Ver catálogo', style: TextStyle(color: _inkSoft, fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
