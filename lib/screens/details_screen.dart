import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    super.key,
    required this.imagePath, 
    required this.heroName, 
    this.description =
        'Super smash bros ultimate villagers from the animal crossing series. This troops fight most effectively in large group',
  });

  final String imagePath;
  final String heroName;
  final String description;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  static const double appBarHeight = 64;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF4E342), Color(0xFFEE3474)],
            begin: Alignment(0.3, -1),
            end: Alignment(-0.8, 1),
          ),
        ),
        child: Stack(
          children: [
         
            ListView(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: appBarHeight + 12, bottom: 28),
              children: [
                // Imagen en 3 capas + personaje
                _HeroDetailsImage(widget.imagePath),

                const SizedBox(height: 20),

                // Nombre del héroe 
                _HeroDetailsName(widget.heroName),

                const SizedBox(height: 12),

                // Descripción
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12),
                  child: Text(
                    widget.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 28),

                // Botones
                Row(
                  children: [
                    const SizedBox(width: 28),

                    // Add Favourite 
                    Expanded(
                      child: SizedBox(
                        height: 54,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Add Favourite',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

          
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80),
                            ),
                          ),
                          child: Ink(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFF29758), Color(0xFFEF5D67)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(80.0)),
                            ),
                            child: const SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: Center(
                                child: Text(
                                  'OK',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 28),
                  ],
                ),

                const SizedBox(height: 28),
              ],
            ),

        
            SafeArea(
              child: SizedBox(
                height: appBarHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 18),
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Text(
                      'Overview',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Expanded(child: SizedBox(height: 80)),
                    const SizedBox(
                      width: 80,
                      height: 80,
                      child: Icon(Icons.menu, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class _HeroDetailsImage extends StatelessWidget {
  const _HeroDetailsImage(this.imagePath);
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: const BorderRadius.all(Radius.circular(28)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: const BorderRadius.all(Radius.circular(28)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.40),
                  borderRadius: const BorderRadius.all(Radius.circular(28)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroDetailsName extends StatelessWidget {
  const _HeroDetailsName(this.heroName);
  final String heroName;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: Text(
              heroName,
              style: TextStyle(
                color: Colors.white.withOpacity(0.10),
                fontWeight: FontWeight.bold,
                fontSize: 56,
              ),
            ),
          ),
        ),
        const SizedBox.shrink(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            heroName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 42,
            ),
          ),
        ),
      ],
    );
  }
}
