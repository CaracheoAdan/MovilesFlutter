import 'package:flutter/material.dart';
import 'package:movilesejmplo1/screens/challenge_screen.dart';
import 'package:movilesejmplo1/screens/home_screen.dart';
import 'package:movilesejmplo1/screens/login_screen.dart';
import 'package:movilesejmplo1/screens/register_screen.dart';
import 'package:movilesejmplo1/utils/theme_app.dart';
import 'package:movilesejmplo1/utils/value_listener.dart';
import 'package:movilesejmplo1/screens/list_movies.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ValueListener.isDark,
      builder: (context, value, _ ) {
        return MaterialApp(
         theme: value ? ThemeApp.darkTheme() : ThemeApp.ligthTheme(),
          routes: {
            "/login" : (context) => LoginScreen(),
            "/home": (context) => HomeScreen(),
            "/listdb" : (context) => const ListMovies(),
            "/challenge" : (context) => ChallengeScreen(),
            "/register" : (context) => RegisterScreen(),
          }, 
          title: 'Material App',
          home: LoginScreen(),
        );
      }
    );
  }
}
