import 'package:flutter/material.dart';

class PlayfigmaScreen extends StatefulWidget {
  const PlayfigmaScreen({super.key});

  @override
  State<PlayfigmaScreen> createState() => _PlayfigmaScreenState();
}

class _PlayfigmaScreenState extends State<PlayfigmaScreen> {
  double _knob = 0.5;

  final Color _psBlue = const Color(0xFF3B82F6);
  final Color _pageBg = const Color(0xFFF2F5FA);
  final Color _header = const Color(0xFF10161F);

  void _goToDetails() => Navigator.pushNamed(context, '/Playfigmadetails');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _psBlue, 
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Container(
              color: _pageBg,
              child: Column(
                children: [
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
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B2230),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: _goToDetails,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Icon(Icons.sports_esports,
                            color: Colors.white, size: 22),
                        const SizedBox(width: 6),
                        const Text(
                          'PS5',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.search, color: Colors.white),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Center(child: _OutlineTitle()),
                          ),
                        ),
                        Positioned(
                          top: 36,
                          left: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _goToDetails,
                            child: Image.network(
                              'https://i.imgur.com/3h4J9rJ.png',
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 84,
                          child: _OvalKnob(
                            width: 230,
                            border: _psBlue.withOpacity(.6),
                            knob: _knob,
                            onChanged: (v) => setState(() => _knob = v),
                          ),
                        ),

                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Row(
                            children: const [
                              Expanded(
                                child: _FeatureCard(
                                  icon: Icons.mic_none_rounded,
                                  title: 'Built-In',
                                  subtitle: 'Microphone',
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _FeatureCard(
                                  icon: Icons.headset_rounded,
                                  title: 'Headset',
                                  subtitle: 'Jack',
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _FeatureCard(
                                  icon: Icons.sensors_rounded,
                                  title: 'Motion',
                                  subtitle: 'Sensor',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _psBlue,
                          shape: const StadiumBorder(),
                          elevation: 0,
                        ),
                        onPressed: _goToDetails, 
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                '\$70',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Buy Now',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
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

class _OutlineTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = Colors.black12;
    return Text(
      'DUAL\nSENSE',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 64,
        height: 0.9,
        letterSpacing: 3,
        fontWeight: FontWeight.w900,
        foreground: stroke,
      ),
    );
  }
}

class _OvalKnob extends StatelessWidget {
  final double width;
  final Color border;
  final double knob; // 0.0 - 1.0
  final ValueChanged<double> onChanged;

  const _OvalKnob({
    required this.width,
    required this.border,
    required this.knob,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const double height = 64;
    const double knobSize = 16;

    return SizedBox(
      width: width,
      height: height,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: (d) {
          final box = context.findRenderObject() as RenderBox;
          final local = box.globalToLocal(d.globalPosition);
          double v = (local.dx - knobSize / 2) / (width - knobSize);
          v = v.clamp(0.0, 1.0);
          onChanged(v);
        },
        child: Stack(
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: border, width: 1.4),
              ),
            ),
            Positioned(
              left: (width - knobSize) * knob,
              top: (height - knobSize) / 2,
              child: Container(
                width: knobSize,
                height: knobSize,
                decoration: BoxDecoration(
                  color: border,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black87, size: 22),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 11,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
