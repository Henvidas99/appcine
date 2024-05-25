import 'package:flutter/material.dart';
import 'package:the_movie_data_base/styles/theme_data.dart';
import 'screens/login/login_screen.dart';

void main() {
  runApp(const MyApp());
} 


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      home: const LoginScreen(),
    );
  }
}