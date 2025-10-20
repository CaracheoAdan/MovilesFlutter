import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movilesejmplo1/firebase_options.dart';
import 'package:movilesejmplo1/screens/add_movie_screen.dart';
import 'package:movilesejmplo1/screens/add_song_screen.dart';
import 'package:movilesejmplo1/screens/challenge_screen.dart';
import 'package:movilesejmplo1/screens/challengefigma_screen.dart';
import 'package:movilesejmplo1/screens/home_screen.dart';
import 'package:movilesejmplo1/screens/list_songs.dart';
import 'package:movilesejmplo1/screens/login_screen.dart';
import 'package:movilesejmplo1/screens/mealfigma_screen.dart';
import 'package:movilesejmplo1/screens/playfigma_screen.dart';
import 'package:movilesejmplo1/screens/playfigmadetails_screen.dart';
import 'package:movilesejmplo1/screens/register_screen.dart';
import 'package:movilesejmplo1/utils/theme_app.dart';
import 'package:movilesejmplo1/utils/value_listener.dart';
import 'package:movilesejmplo1/screens/list_movies.dart';

void main() async {
  {
  WidgetsFlutterBinding.ensureInitialized();  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  }
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
            "/challengeFigma" : (context) => ChallengefigmaScreen(),
            "/register" : (context) => RegisterScreen(),
            "/Mealfigma" : (context) => MealfigmaScreen(),
            '/Playfigma': (context) => const PlayfigmaScreen(),
            '/Playfigmadetails': (context) => const PlayfigmadetailsScreen(),
            '/add': (context) => const AddMovieScreen(),
            '/miusiclist': (context) => const ListSongs(),
            '/addsong': (context) => const AddSongScreen(),
          }, 
          title: 'Material App',
          home: LoginScreen(),
        );
      }
    );
  }
}
