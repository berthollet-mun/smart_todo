import 'package:flutter/material.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/hospital/hospital_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Todo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        useMaterial3: true,
      ),
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        SignupScreen.routeName: (context) => const SignupScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        HospitalScreen.routeName: (context) => const HospitalScreen(),
      },
    );
  }
}
