import 'package:flutter/material.dart';

class MealfigmaScreen extends StatefulWidget {
  const MealfigmaScreen({super.key});

  @override
  State<MealfigmaScreen> createState() => _MealfigmaScreenState();
}

class _MealfigmaScreenState extends State<MealfigmaScreen> {
  int _selectedThumb = 1;
  int _qty = 1;
  bool _sauceOpen = true;
  int _selectedSauce = 0;

  final _thumbs = [
    const NetworkImage('https://picsum.photos/seed/kota1/200/200'),
    const NetworkImage('https://picsum.photos/seed/kota2/200/200'),
    const NetworkImage('https://picsum.photos/seed/kota3/200/200'),
  ];

  final _sauces = const [
    ('Tomato Sauce', 'FREE', 0.0),
    ('BBQ Sauce', '+R4.00', 4.0),
    ('Chakalaka sauce', '+R2.00', 2.0),
  ];

  Color get _brandYellow => const Color(0xFFFFB000);
  Color get _tileGray => const Color(0xFFEFEFEF);

  @override
  Widget build(BuildContext context) {
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
                          icon: const Icon(Icons.menu),
                          onPressed: () => Navigator.maybePop(context),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'Create your kota',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(_thumbs.length, (i) {
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
                              image: _thumbs[i],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 18),

                
                  AspectRatio(
                    aspectRatio: 1.4,
                    child: GestureDetector(
                     onTap: () => Navigator.pushNamed(context, '/Playfigma'),
                     child: Center(
                       child: Image(
                          image: _thumbs[
                           (_selectedThumb.clamp(0, _thumbs.length - 1) as int)
                          ],
                          fit: BoxFit.contain,
                        ),
                     ),
                   ),
                  ),

                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    child: Row(
                      children: [
                        const Text(
                          'Select Sauce',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.local_drink_outlined, color: Colors.white),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () => setState(() => _sauceOpen = !_sauceOpen),
                          child: Icon(
                            _sauceOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (_sauceOpen) ...[
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
                      child: Column(
                        children: List.generate(_sauces.length, (i) {
                          final (name, priceLabel, _) = _sauces[i];
                          final selected = _selectedSauce == i;
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
                                      name,
                                      style: TextStyle(
                                        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                                        decoration: selected ? TextDecoration.underline : TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    priceLabel,
                                    style: const TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],

                  const SizedBox(height: 18),

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
                            onPressed: () {
                              Navigator.pushNamed(context, '/Playfigmadetails');
                            },
                            child: const Text(
                              'Checkout',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
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
                              onPressed: () => setState(() => _qty = (_qty - 1).clamp(1, 99) as int),
                              icon: const Icon(Icons.remove),
                            ),
                            Text('$_qty',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                            IconButton(
                              onPressed: () => setState(() => _qty = (_qty + 1).clamp(1, 99) as int),
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const SizedBox(height: 36),
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
