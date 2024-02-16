import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/home.dart';
import 'screens/signup.dart';

void main() async {
  //Ensure widgets initialized before executing other tasks
  WidgetsFlutterBinding.ensureInitialized();
  //initialize Firebase before using other services of firebase
  await Firebase.initializeApp(
    //retrieves the default options based on the current platform the Flutter app is running on
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Movie App",
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
        ),
        fontFamily: "Poppins",
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        fontFamily: "Poppins",
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? const SignUp()
          : const Home(),
    );
  }
}
