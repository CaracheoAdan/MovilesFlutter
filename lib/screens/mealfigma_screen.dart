import 'package:flutter/material.dart';
import 'package:movilesejmplo1/database/food_database.dart';
import 'package:movilesejmplo1/models/product_dao.dart';
import 'package:movilesejmplo1/models/sauce_dao.dart';
import 'package:movilesejmplo1/models/drink_dao.dart';

class MealfigmaScreen extends StatefulWidget {
  const MealfigmaScreen({super.key});

  @override
  State<MealfigmaScreen> createState() => _MealfigmaScreenState();
}

class _MealfigmaScreenState extends State<MealfigmaScreen> {
  final db = FoodDatabase();

  // Estado UI
  int _selectedThumb = 0;
  int _qty = 1;
  bool _sauceOpen = true;
  int _selectedSauce = 0;

  // Datos dinámicos
  List<ProductDao> _products = [];
  List<SauceDao> _sauces = [];
  List<DrinkDao> _drinks = [];
  DrinkDao? _selectedDrink;
  bool _isLoading = true;
  int _cartCount = 0;

  // Colores
  Color get _brandYellow => const Color(0xFFFFB000);
  Color get _tileGray => const Color(0xFFEFEFEF);
  Color get _ink => const Color(0xFF0F172A);       // texto principal
  Color get _inkSoft => const Color(0xFF475569);   // texto secundario

  @override
  void initState() {
    super.initState();
    _loadCatalogs();
    _loadCartCount();
  }

  Future<void> _loadCatalogs() async {
    final products = await db.selectProducts();
    final sauces   = await db.selectSauces();
    final drinks   = await db.selectDrinks();
    if (!mounted) return;
    setState(() {
      _products = products;
      _sauces   = sauces;
      _drinks   = drinks;
      if (_products.isNotEmpty) _selectedThumb = 0;
      if (_sauces.isNotEmpty) _selectedSauce = 0;
      _selectedDrink = null;
      _isLoading = false;
    });
  }

  Future<void> _loadCartCount() async {
    final items = await db.selectCart();
    if (!mounted) return;
    setState(() => _cartCount = items.fold<int>(0, (s, e) => s + (e.qty ?? 0)));
  }

  // ====== Apartado FORMS / CRUD ======
  Future<void> _openFormsSheet() async {
    await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            const Text('Admin / Forms', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Products (CRUD)'),
              onTap: () async {
                Navigator.pop(ctx, true);
                await Navigator.pushNamed(context, '/listProducts');
                await _loadCatalogs();
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Sauces (CRUD)'),
              onTap: () async {
                Navigator.pop(ctx, true);
                await Navigator.pushNamed(context, '/listSauces');
                await _loadCatalogs();
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Drinks (CRUD)'),
              onTap: () async {
                Navigator.pop(ctx, true);
                await Navigator.pushNamed(context, '/listDrinks');
                await _loadCatalogs();
              },
            ),
            const Divider(height: 8),
            ListTile(
              leading: const Icon(Icons.edit_note),
              title: const Text('New / Edit Product'),
              onTap: () async {
                Navigator.pop(ctx, true);
                await Navigator.pushNamed(context, '/formProduct');
                await _loadCatalogs();
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_note),
              title: const Text('New / Edit Sauce'),
              onTap: () async {
                Navigator.pop(ctx, true);
                await Navigator.pushNamed(context, '/formSauce');
                await _loadCatalogs();
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_note),
              title: const Text('New / Edit Drink'),
              onTap: () async {
                Navigator.pop(ctx, true);
                await Navigator.pushNamed(context, '/formDrink');
                await _loadCatalogs();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // Helpers
  String _money(int cents) => 'R${(cents / 100).toStringAsFixed(2)}';
  int get _selectedProductPrice => _products.isEmpty ? 0 : (_products[_selectedThumb].price ?? 0);
  int get _selectedSauceExtra   => _sauces.isEmpty ? 0 : (_sauces[_selectedSauce].extra ?? 0);
  int get _selectedDrinkPrice   => _selectedDrink?.price ?? 0;
  int get _lineTotal => (_selectedProductPrice + _selectedSauceExtra + _selectedDrinkPrice) * _qty;

  ImageProvider _imageFor(ProductDao p) {
    final img = p.image ?? '';
    if (img.startsWith('http')) return NetworkImage(img);
    if (img.isNotEmpty) return AssetImage(img);
    return const NetworkImage('https://picsum.photos/seed/kota/400/300');
  }

  Future<void> _onCheckout() async {
    if (_products.isEmpty) return;
    final product = _products[_selectedThumb];
    final sauce   = _sauces.isNotEmpty ? _sauces[_selectedSauce] : null;

    await db.cartAdd(
      idProduct: product.idProduct!,
      qty: _qty,
      idSauce: sauce?.idSauce,
      idDrink: _selectedDrink?.idDrink,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Agregado al carrito: ${product.name} x$_qty')),
    );
    await _loadCartCount();
  }

  // Ir al catálogo PlayfigmaDetails
  void _goToPlayCatalog() {
    Navigator.pushNamed(context, '/Playfigmadetails');
  }

  @override
  Widget build(BuildContext context) {
    final loading = _isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: _brandYellow,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.menu, color: Colors.black),
                          onPressed: () => Navigator.maybePop(context),
                        ),
                      ),
                      const Spacer(),
                      // Catálogo
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.sports_esports, color: Colors.white),
                          tooltip: 'Catálogo',
                          onPressed: _goToPlayCatalog,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                              tooltip: 'Ver carrito',
                              onPressed: () async {
                                await Navigator.pushNamed(context, '/cart');
                                await _loadCartCount();
                                await _loadCatalogs();
                              },
                            ),
                          ),
                          if (_cartCount > 0)
                            Positioned(
                              right: -4,
                              top: -4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text('$_cartCount',
                                    style: const TextStyle(color: Colors.white, fontSize: 12)),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      // Forms
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          onPressed: _openFormsSheet,
                          icon: const Icon(Icons.admin_panel_settings),
                          label: const Text('Forms'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Título
                  Center(
                    child: Text(
                      'Create your kota',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (loading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(28.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else ...[
                    // Thumbnails productos
                    if (_products.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _EmptyInlineButton(
                          text: 'No hay productos. Agrega uno',
                          onTap: () => Navigator.pushNamed(context, '/formProduct')
                              .then((_) => _loadCatalogs()),
                        ),
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(_products.length, (i) {
                          final selected = _selectedThumb == i;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedThumb = i),
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: selected ? Colors.black : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: _brandYellow, width: 2),
                                boxShadow: selected
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(.15),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        )
                                      ]
                                    : null,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image(
                                  image: _imageFor(_products[i]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                    const SizedBox(height: 18),

                    // Imagen principal
                    if (_products.isNotEmpty)
                      AspectRatio(
                        aspectRatio: 1.4,
                        child: Center(
                          child: Image(
                            image: _imageFor(_products[_selectedThumb]),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                    const SizedBox(height: 8),

                    // Selector de salsas
                    _SectionHeader(
                      title: 'Select Sauce',
                      trailing: const Icon(Icons.local_drink_outlined, color: Colors.white),
                      expanded: _sauceOpen,
                      onToggle: () => setState(() => _sauceOpen = !_sauceOpen),
                    ),

                    if (_sauceOpen)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.06),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: (_sauces.isEmpty)
                            ? Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: _EmptyInlineButton(
                                  text: 'No hay salsas. Agrega una',
                                  onTap: () => Navigator.pushNamed(context, '/formSauce')
                                      .then((_) => _loadCatalogs()),
                                ),
                              )
                            : Column(
                                children: List.generate(_sauces.length, (i) {
                                  final sauce = _sauces[i];
                                  final selected = _selectedSauce == i;
                                  final priceLabel =
                                      (sauce.extra ?? 0) == 0 ? 'FREE' : '+${_money(sauce.extra ?? 0)}';
                                  return InkWell(
                                    onTap: () => setState(() => _selectedSauce = i),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                      decoration: BoxDecoration(
                                        color: selected ? _tileGray : Colors.white,
                                        border: Border(
                                          top: BorderSide(color: Colors.grey.shade300, width: 1),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              sauce.name ?? 'Sauce',
                                              style: TextStyle(
                                                color: _ink,
                                                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                                                decoration: selected
                                                    ? TextDecoration.underline
                                                    : TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            priceLabel,
                                            style: TextStyle(color: _ink, fontWeight: FontWeight.w800),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                      ),

                    const SizedBox(height: 18),

                    // BEBIDAS
                    Text('Do you want a drink?',
                        style: TextStyle(color: _ink, fontWeight: FontWeight.w900, fontSize: 16)),
                    const SizedBox(height: 8),

                    if (_drinks.isEmpty)
                      _EmptyInlineButton(
                        text: 'No hay bebidas. Agrega una',
                        onTap: () => Navigator.pushNamed(context, '/formDrink')
                            .then((_) => _loadCatalogs()),
                      )
                    else
                      SizedBox(
                        height: 96,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _drinks.length + 1, // +1 para "None"
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (ctx, i) {
                            if (i == 0) {
                              final selected = _selectedDrink == null;
                              return _DrinkChip(
                                label: 'None',
                                sublabel: '',
                                selected: selected,
                                onTap: () => setState(() => _selectedDrink = null),
                              );
                            }
                            final d = _drinks[i - 1];
                            final selected = _selectedDrink?.idDrink == d.idDrink;
                            return _DrinkChip(
                              label: d.name ?? '',
                              sublabel: '${d.size ?? ''} · ${_money(d.price ?? 0)}',
                              selected: selected,
                              onTap: () => setState(() => _selectedDrink = d),
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 18),

                    // Total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: TextStyle(color: _ink, fontSize: 16, fontWeight: FontWeight.w900)),
                        Text(_money(_lineTotal),
                            style: TextStyle(color: _ink, fontSize: 16, fontWeight: FontWeight.w900)),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              onPressed: (_products.isEmpty) ? null : _onCheckout,
                              child: const Text(
                                'Checkout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.06),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () => setState(() {
                                  _qty = ((_qty - 1).clamp(1, 99)).toInt();
                                }),
                                icon: const Icon(Icons.remove),
                                color: _ink,
                              ),
                              Text('$_qty',
                                  style: TextStyle(color: _ink, fontSize: 16, fontWeight: FontWeight.w800)),
                              IconButton(
                                onPressed: () => setState(() {
                                  _qty = ((_qty + 1).clamp(1, 99)).toInt();
                                }),
                                icon: const Icon(Icons.add),
                                color: _ink,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 36),
                  ],
                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 24,
                width: double.infinity,
                color: _brandYellow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final bool expanded;
  final VoidCallback onToggle;
  const _SectionHeader({
    required this.title,
    this.trailing,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          if (trailing != null) trailing!,
          const SizedBox(width: 8),
          InkWell(
            onTap: onToggle,
            child: Icon(
              expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrinkChip extends StatelessWidget {
  final String label;
  final String sublabel;
  final bool selected;
  final VoidCallback onTap;
  const _DrinkChip({
    required this.label,
    required this.sublabel,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.black : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 180,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFFB000), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF0F172A),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                sublabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? Colors.white70 : const Color(0xFF475569),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyInlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _EmptyInlineButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.add),
      label: Text(text),
    );
  }
}
