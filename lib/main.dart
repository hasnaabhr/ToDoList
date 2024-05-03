import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/pages/home_page.dart';
import 'package:todolist/pages/login_page.dart';
import 'package:todolist/pages/onboarding.dart';
import 'package:todolist/pages/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter("hive_boxes");

  // ignore: prefer_const_constructors
  final FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyBLOK2O5uc-T1OcucdNKw2AvUDHs_7CSY4",
    appId: "1:970993254671:android:e37c8fb2e612fb1415fe7a",
    messagingSenderId: "970993254671",
    projectId: "taskly-4cb5a",
    storageBucket: "taskly-4cb5a.appspot.com",
  );

  await Firebase.initializeApp(options: firebaseOptions);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const OnBoardingScreen(),

      // Other properties
      routes: {
        '/signup': (context) => const SignUpPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
