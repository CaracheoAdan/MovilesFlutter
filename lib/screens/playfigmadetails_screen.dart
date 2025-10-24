import 'package:flutter/material.dart';
import 'package:movilesejmplo1/database/food_database.dart';
import 'package:movilesejmplo1/models/product_dao.dart';

class PlayfigmadetailsScreen extends StatefulWidget {
  const PlayfigmadetailsScreen({super.key});
  @override
  State<PlayfigmadetailsScreen> createState() => _PlayfigmadetailsScreenState();
}

class _PlayfigmadetailsScreenState extends State<PlayfigmadetailsScreen> {
  final db = FoodDatabase();

  // Colores con más contraste
  final Color _brand = const Color(0xFF2563EB);
  final Color _pageBg = const Color(0xFFF7F7F9);
  final Color _ink = const Color(0xFF0F172A);
  final Color _inkSoft = const Color(0xFF475569);

  List<ProductDao> _all = [];
  List<ProductDao> _filtered = [];
  bool _loading = true;

  final _searchCtrl = TextEditingController();
  String _sort = 'Nombre';

  String _money(int cents) => 'R${(cents / 100).toStringAsFixed(2)}';

  @override
  void initState() {
    super.initState();
    _load();
    _searchCtrl.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final products = await db.selectProducts();
    if (!mounted) return;
    setState(() {
      _all = products;
      _loading = false;
    });
    _applyFilters();
  }

  void _applyFilters() {
    var list = List<ProductDao>.from(_all);
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((p) => (p.name ?? '').toLowerCase().contains(q)).toList();
    }
    switch (_sort) {
      case 'Nombre':
        list.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
        break;
      case 'Precio ↑':
        list.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
        break;
      case 'Precio ↓':
        list.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
        break;
    }
    setState(() => _filtered = list);
  }

  ImageProvider _imageFor(ProductDao p) {
    final img = p.image ?? '';
    if (img.startsWith('http')) return NetworkImage(img);
    if (img.isNotEmpty) return AssetImage(img);
    return const NetworkImage('https://picsum.photos/seed/prod/320/200');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _brand,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _ink,
        foregroundColor: Colors.white,
        onPressed: () async {
          await Navigator.pushNamed(context, '/formProduct');
          await _load();
        },
        icon: const Icon(Icons.add),
        label: const Text('Producto'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Container(
              color: _pageBg,
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                    child: Row(
                      children: [
                        _roundBtn(
                          icon: Icons.arrow_back,
                          onTap: () => Navigator.maybePop(context),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.storefront_rounded, size: 22, color: Colors.black87),
                        const SizedBox(width: 8),
                        Text('Catálogo',
                            style: TextStyle(
                              color: _ink,
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              letterSpacing: 0.3,
                            )),
                        const Spacer(),
                        _roundBtn(icon: Icons.refresh, onTap: _load),
                      ],
                    ),
                  ),

                  // Filtros
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchCtrl,
                            style: TextStyle(color: _ink, fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              hintText: 'Buscar producto...',
                              hintStyle: TextStyle(color: _inkSoft),
                              prefixIcon: Icon(Icons.search, color: _inkSoft),
                              isDense: true,
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: _inkSoft.withOpacity(.3)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: _inkSoft.withOpacity(.3)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        DropdownButtonHideUnderline(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _inkSoft.withOpacity(.3)),
                            ),
                            child: DropdownButton<String>(
                              value: _sort,
                              items: const [
                                DropdownMenuItem(value: 'Nombre', child: Text('Nombre')),
                                DropdownMenuItem(value: 'Precio ↑', child: Text('Precio ↑')),
                                DropdownMenuItem(value: 'Precio ↓', child: Text('Precio ↓')),
                              ],
                              onChanged: (v) {
                                if (v == null) return;
                                setState(() => _sort = v);
                                _applyFilters();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: _loading
                        ? const Center(child: CircularProgressIndicator())
                        : (_filtered.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('No hay productos', style: TextStyle(color: _ink)),
                                    const SizedBox(height: 8),
                                    OutlinedButton.icon(
                                      onPressed: () => Navigator.pushNamed(context, '/formProduct').then((_) => _load()),
                                      icon: const Icon(Icons.add),
                                      label: const Text('Agregar producto'),
                                    ),
                                  ],
                                ),
                              )
                            : RefreshIndicator(
                                onRefresh: _load,
                                child: GridView.builder(
                                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                                  itemCount: _filtered.length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 14,
                                    mainAxisSpacing: 14,
                                    childAspectRatio: .74,
                                  ),
                                  itemBuilder: (context, i) {
                                    final item = _filtered[i];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/Playfigma',
                                          arguments: {'idProduct': item.idProduct},
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(18),
                                          boxShadow: [
                                            BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 12, offset: const Offset(0, 6)),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: _pricePill(_money(item.price ?? 0)),
                                            ),
                                            const SizedBox(height: 6),
                                            Expanded(
                                              child: Center(
                                                child: Image(
                                                  image: _imageFor(item),
                                                  fit: BoxFit.contain,
                                                  height: 90,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text('Producto',
                                                style: TextStyle(
                                                  color: _inkSoft,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                )),
                                            const SizedBox(height: 4),
                                            Text(item.name ?? '',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: _ink,
                                                  height: 1.05,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                )),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _pricePill(String price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _ink.withOpacity(.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(price, style: TextStyle(color: _ink, fontWeight: FontWeight.w800)),
    );
  }

  Widget _roundBtn({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Icon(icon, size: 20, color: _ink),
      ),
    );
  }
}
