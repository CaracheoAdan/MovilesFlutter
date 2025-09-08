import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:movilesejmplo1/utils/value_listener.dart';

enum _SelectedTab { home, favorite, search, profile }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _selectedTab = _SelectedTab.home;

  final TextEditingController _userCtrl = TextEditingController();
  final TextEditingController _pwdCtrl = TextEditingController();
  bool isValidating = false;

  void _handleIndexChanged(int index) {
    setState(() {
      _selectedTab = _SelectedTab.values[index];
    });
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: ValueListener.isDark,
            builder: (context, isDark, _) {
              return IconButton(
                icon: Icon(isDark ? Icons.wb_sunny : Icons.nights_stay),
                onPressed: () => ValueListener.isDark.value = !isDark,
              );
            },
          ),
        ],
      ),
      drawer: const Drawer(),
      body: Stack(
        children: [
          const Center(child: Text("Screen Nueva")),
          Positioned(
            left: 0,
            right: 0,
            bottom: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              height: MediaQuery.of(context).size.height * .2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: ListView(
                children: [
                  // aquí podrías poner tus TextFields si los necesitas
                  IconButton(
                    onPressed: () {
                      isValidating = true;
                      setState(() {});
                      Future.delayed(const Duration(milliseconds: 3000)).then((_) {
                        if (!mounted) return;
                        Navigator.pushNamed(context, '/challenge');
                      });
                    },
                    icon: const Icon(Icons.login, size: 40),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: DotNavigationBar(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          currentIndex: _SelectedTab.values.indexOf(_selectedTab),
          dotIndicatorColor: Colors.white,
          unselectedItemColor: Colors.grey[300],
          splashBorderRadius: 50,
          onTap: _handleIndexChanged,
          items:  [
            DotNavigationBarItem(icon: Icon(Icons.home), selectedColor: Color(0xff73544C)),
            DotNavigationBarItem(icon: Icon(Icons.favorite), selectedColor: Color(0xff73544C)),
            DotNavigationBarItem(icon: Icon(Icons.search), selectedColor: Color(0xff73544C)),
            DotNavigationBarItem(icon: Icon(Icons.person), selectedColor: Color(0xff73544C)),
          ],
        ),
      ),
    );
  }
}
