import 'package:flutter/material.dart';

class PlayfigmadetailsScreen extends StatefulWidget {
  const PlayfigmadetailsScreen({super.key});

  @override
  State<PlayfigmadetailsScreen> createState() => _PlayfigmadetailsScreenState();
}

class _PlayfigmadetailsScreenState extends State<PlayfigmadetailsScreen> {
  final Color _psBlue = const Color(0xFF3B82F6);
  final Color _pageBg = const Color(0xFFF2F5FA);

  int _selectedIndex = 1; 
  final Set<int> _favs = {1};

  final List<({String cat, String name, String asset})> _items = const [
    (cat: 'Game console', name: 'Playstation 5\nDigital Edition', asset: 'assets/ps5_digital.png'),
    (cat: 'Game console', name: 'Playstation 5', asset: 'assets/ps5.png'),
    (cat: 'Gaming Controller', name: 'DualSense\nWireless Controller', asset: 'assets/dualsense.png'),
    (cat: 'Audio and Communication', name: 'Wireless\nHeadset', asset: 'assets/headset.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _psBlue,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Container(
                  color: _pageBg,
                  child: Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                        child: Row(
                          children: [
                            _roundBtn(icon: Icons.menu),
                            const SizedBox(width: 12),
                            const Icon(Icons.sports_esports, size: 22),
                            const SizedBox(width: 6),
                            const Text('PS5', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: 1.2)),
                            const Spacer(),
                            _roundBtn(icon: Icons.settings),
                          ],
                        ),
                      ),

                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 110),
                          itemCount: _items.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: .74,
                          ),
                          itemBuilder: (context, i) {
                            final item = _items[i];
                            final selected = i == _selectedIndex;

                            return GestureDetector(
                              onTap: () {
                                setState(() => _selectedIndex = i);
                                Navigator.pushNamed(
                                  context,
                                  '/Playfigma',
                                  arguments: {
                                    'cat': item.cat,
                                    'name': item.name,
                                    'asset': item.asset,
                                  },
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selected ? _psBlue.withOpacity(.18) : Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 12, offset: const Offset(0, 6)),
                                  ],
                                  border: Border.all(color: selected ? _psBlue : Colors.transparent, width: selected ? 2 : 0),
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: InkWell(
                                        onTap: () => setState(() => _favs.contains(i) ? _favs.remove(i) : _favs.add(i)),
                                        child: Icon(
                                          _favs.contains(i) ? Icons.favorite : Icons.favorite_border,
                                          color: _favs.contains(i) ? _psBlue : Colors.black26,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Expanded(
                                      child: Center(
                                        child: Image.asset(item.asset, fit: BoxFit.contain, height: 90),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(item.cat,
                                        style: const TextStyle(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    Text(item.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: _psBlue, height: 1.05, fontWeight: FontWeight.w800)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              left: 26,
              right: 26,
              bottom: 26,
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF10161F),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.25), blurRadius: 16, offset: const Offset(0, 8))],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _NavIcon(icon: Icons.home_filled),
                    _NavIcon(icon: Icons.search),
                    _NavIcon(icon: Icons.sports_esports),
                    _NavIcon(icon: Icons.shopping_cart_outlined),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundBtn({required IconData icon}) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Icon(icon, size: 20),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  const _NavIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(splashRadius: 24, onPressed: () {}, icon: Icon(icon, color: Colors.white70));
  }
}
