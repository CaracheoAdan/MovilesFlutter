import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'details_screen.dart';

/* Pantalla con la lista de 3 héroes */
class ChallengeScreen extends StatelessWidget {
  const ChallengeScreen({super.key});

  static const Color bg = Color(0xFFF0625D);

  // Tres héroes con nombre, imagen y stats
  final List<Map<String, dynamic>> heroes = const [
    {
      'name': 'Barbarian',
      'image': 'assets/Player-1.png',
      'speed': 75.0,
      'health': 65.0,
      'attack': 90.0,
    },
    {
      'name': 'Ice Golem',
      'image': 'assets/Player-2.png',
      'speed': 60.0,
      'health': 80.0,
      'attack': 70.0,
    },
    {
      'name': 'Dwarf',
      'image': 'assets/Player-3.png',
      'speed': 85.0,
      'health': 55.0,
      'attack': 95.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: false,
        title: const Text('Flutter4Fun.com'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 24),
        itemCount: heroes.length,
        itemBuilder: (context, i) {
          final h = heroes[i];
          return HeroRow(
            name: h['name'],
            image: h['image'],
            speed: h['speed'],
            health: h['health'],
            attack: h['attack'],
          );
        },
      ),
    );
  }
}

/* ----------------- Widget reutilizable de cada héroe ----------------- */
class HeroRow extends StatelessWidget {
  final String name;
  final String image;
  final double speed;
  final double health;
  final double attack;

  const HeroRow({
    super.key,
    required this.name,
    required this.image,
    required this.speed,
    required this.health,
    required this.attack,
  });

  // Alturas base de la composición
  static const double rowHeight = 188;         // alto del héroe
  static const double backPlaneHeight = 216;   // plano posterior
  static const double frontPlaneHeight = 188;  // plano frontal

  double _deg(double d) => d * math.pi / 180;

  @override
  Widget build(BuildContext context) {
   
    final double attrSize = frontPlaneHeight * 0.26; 

    return Container(
      height: backPlaneHeight + 40, // espacio para ambos planos
      margin: const EdgeInsets.only(bottom: 24),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
        
          Transform.translate(
            offset: const Offset(-10, 0),
            child: Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.01)
                ..rotateY(_deg(1.5)),
              child: Container(
                height: backPlaneHeight,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: const BorderRadius.all(Radius.circular(22)),
                ),
              ),
            ),
          ),

          
          Transform.translate(
            offset: const Offset(-44, 0),
            child: Transform(
              alignment: FractionalOffset.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.01)
                ..rotateY(_deg(8)),
              child: Container(
                height: frontPlaneHeight,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.40),
                  borderRadius: const BorderRadius.all(Radius.circular(22)),
                ),
              ),
            ),
          ),

          // Imagen del héroe (izquierda)
          Align(
            alignment: Alignment.centerLeft,
            child: Transform.translate(
              offset: const Offset(-30, 0),
              child: SizedBox(
                width: rowHeight,
                height: rowHeight,
                child: Image.asset(image, fit: BoxFit.contain),
              ),
            ),
          ),

          // Atributos + botón (derecha) — contenido acotado a frontPlaneHeight
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.only(right: 58),
              child: SizedBox(
                height: frontPlaneHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AttributeWidget(
                      progress: speed,
                      size: attrSize,
                      child: Image.asset('assets/speed.png'),
                    ),
                    AttributeWidget(
                      progress: health,
                      size: attrSize,
                      child: const Icon(Icons.favorite, color: Colors.white),
                    ),
                    AttributeWidget(
                      progress: attack,
                      size: attrSize,
                      child: Image.asset('assets/knife.png'),
                    ),
                    SizedBox(
                      height: 32,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DetailsScreen(
                                imagePath: image,
                                heroName: name, 
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          visualDensity: VisualDensity.compact,
                        ),
                        child: const Text('See Details', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class AttributePainter extends CustomPainter {
  final double progressPercent;
  final double strokeWidth;
  final double filledStrokeWidth;

  final Paint bgPaint;
  final Paint strokeBgPaint;
  final Paint strokeFilledPaint;

  AttributePainter({
    required this.progressPercent,
    this.strokeWidth = 4.0,
    this.filledStrokeWidth = 8.0,
  })  : bgPaint = Paint()..color = Colors.white.withOpacity(0.25),
        strokeBgPaint = Paint()..color = const Color(0xFFD264C9),
        strokeFilledPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = filledStrokeWidth
          ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Círculo de fondo
    canvas.drawCircle(center, radius, bgPaint);

    // Anillo de fondo
    canvas.drawCircle(center, radius - strokeWidth, strokeBgPaint);

    // Arco de progreso 
    final rect = Rect.fromCircle(center: center, radius: radius - (strokeWidth / 2));
    const startAngle = -math.pi / 2;
    final sweepAngle = (progressPercent / 100) * math.pi * 2;

    canvas.drawArc(rect, startAngle, sweepAngle, false, strokeFilledPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AttributeWidget extends StatelessWidget {
  final double size;
  final double progress;
  final Widget? child;

  const AttributeWidget({
    super.key,
    required this.progress,
    this.size = 82,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: AttributePainter(progressPercent: progress),
      size: Size(size, size),
      child: Container(
        padding: EdgeInsets.all(size / 3.8),
        width: size,
        height: size,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
                  