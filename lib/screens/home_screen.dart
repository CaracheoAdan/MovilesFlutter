import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:movilesejmplo1/screens/challenge_screen.dart';
import 'package:movilesejmplo1/screens/api_movie_list.dart'; 
import 'package:movilesejmplo1/utils/value_listener.dart';

enum _SelectedTab { home, favorite, search, profile, home_work }

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
    final currentIndex = _SelectedTab.values.indexOf(_selectedTab);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text('Campos Caracheo Adan Javier'),
              accountEmail: Text('21031400@itcelaya.edu.mc'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
              ),
            ),
            ListTile(
              leading: Image.asset('assets/IconElegant.png'),
              title: const Text('List Movies'),
              subtitle: const Text('Database Movies'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedTab = _SelectedTab.home);
              },
            ),
            ListTile(
              leading: Image.asset('assets/practica1_icon.png'),
              title: const Text("Practica 1"),
              subtitle: const Text("Challenge Flutter"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, "/challenge"),
            ),
            ListTile(
              leading: Image.asset('assets/practica2_icon.png'),
              title: const Text("Practica3"),
              subtitle: const Text("Challenge Figma"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, "/challengeFigma"),
            ),
            ListTile(
              leading: Image.asset('assets/practica2_icon.png'),
              title: const Text("Music App"),
              subtitle: const Text("Play Music"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, "/miusiclist"),
            ),
          ],
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: IndexedStack(
          key: ValueKey(currentIndex),
          index: currentIndex,
          children: [
            ApiMoviesList(),
            const Center(child: Text('Favorites (pendiente)')),
            const Center(child: Text('Search (pendiente)')),
            const Center(child: Text('Profile (pendiente)')),
            const Center(child: Text('Challenge (abre con el 5° ícono)')),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: DotNavigationBar(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          currentIndex: currentIndex,
          dotIndicatorColor: Colors.white,
          unselectedItemColor: Colors.grey[300],
          splashBorderRadius: 50,
          onTap: (index) {
            if (index == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChallengeScreen()),
              );
            } else {
              _handleIndexChanged(index);
            }
          },
          // OJO: sin "const" en la lista de items
          items: [
            DotNavigationBarItem(
              icon: const Icon(Icons.home),
              selectedColor: const Color.fromARGB(255, 94, 238, 190),
            ),
            DotNavigationBarItem(
              icon: const Icon(Icons.favorite),
              selectedColor: const Color.fromARGB(255, 19, 158, 61),
            ),
            DotNavigationBarItem(
              icon: const Icon(Icons.search),
              selectedColor: const Color.fromARGB(255, 111, 163, 231),
            ),
            DotNavigationBarItem(
              icon: const Icon(Icons.person),
              selectedColor: const Color.fromARGB(255, 230, 227, 72),
            ),
            DotNavigationBarItem(
              icon: const Icon(Icons.home_work),
              selectedColor: const Color.fromARGB(255, 88, 185, 64),
            ),
          ],
        ),
      ),
    );
  }
}
