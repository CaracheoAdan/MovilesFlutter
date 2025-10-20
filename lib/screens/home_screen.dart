import 'package:flutter/material.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:movilesejmplo1/screens/challenge_screen.dart';
import 'package:movilesejmplo1/utils/value_listener.dart';

enum _SelectedTab { home, favorite, search, profile, home_work}

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
              title: Text('List Movies'),
              subtitle: Text('Database Movies'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context,"/listdb"),
            ),
            ListTile(
              leading: Image.asset('assets/practica1_icon.png'),
              title: Text("Practica 1"),
              subtitle:  Text("Challenge Flutter"),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, "/challenge")
            ),
            ListTile(
               leading: Image.asset('assets/practica2_icon.png'),
              title: Text("Practica3"),
              subtitle:  Text("Challenge Figma"),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, "/challengeFigma")
            ),
            ListTile(
               leading: Image.asset('assets/practica2_icon.png'),
              title: Text("Music App"),
              subtitle:  Text("Play Music"),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, "/miusiclist")
            )
          ],
        ),
      ),
      body: Stack(
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: DotNavigationBar(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          currentIndex: _SelectedTab.values.indexOf(_selectedTab),
          dotIndicatorColor: Colors.white,
          unselectedItemColor: Colors.grey[300],
          splashBorderRadius: 50,
          onTap: (index) {
            if (index == 4) { 
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChallengeScreen()),
              );
            }else {
              setState(() {
                _selectedTab = _SelectedTab.values[index];
              });
            }
          },
          items:  [
            DotNavigationBarItem(icon: Icon(Icons.home),
             selectedColor: Color.fromARGB(255, 94, 238, 190)
             ),
            DotNavigationBarItem(icon: Icon(Icons.favorite),
             selectedColor: Color.fromARGB(255, 19, 158, 61))
             ,
            DotNavigationBarItem(icon: Icon(Icons.search),
             selectedColor: Color.fromARGB(255, 111, 163, 231)
             ),
            DotNavigationBarItem(icon: Icon(Icons.person),
             selectedColor: Color.fromARGB(255, 230, 227, 72)
             ),
            DotNavigationBarItem(icon: Icon(Icons.home_work),
             selectedColor: Color.fromARGB(1, 88, 185, 64)
             ),
          ],
        ),
      ),
    );
  }
}
