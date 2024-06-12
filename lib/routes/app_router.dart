
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_movie_data_base/screens/Tabs/tab_account_screen.dart';
import 'package:the_movie_data_base/screens/Tabs/tab_home_screen.dart';
import 'package:the_movie_data_base/screens/Tabs/tab_ticket_screen.dart';
import 'package:the_movie_data_base/screens/login/login_screen.dart';
import 'package:the_movie_data_base/screens/welcome/welcome_screen.dart';
import 'package:the_movie_data_base/styles/theme_data.dart';


class MyRouter extends StatelessWidget {
  final bool isLoggedIn;

  const MyRouter(this.isLoggedIn, {super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = GoRouter(
      initialLocation: isLoggedIn ? '/' : '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const TabHomeScreen(),
        ),
        GoRoute(
          path: '/tickets',
          builder: (context, state) => const TabTicketScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const TabAccountScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: appTheme(),
    );
  }
}