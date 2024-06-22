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
          pageBuilder: (context, state) {
            if (state.extra == 'fromLogout') {
              return CustomTransitionPage(    
                key: state.pageKey,
                child: const LoginScreen(),
                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {

                  final Tween<Offset> slideTween = Tween(begin: const Offset(-1.0, 0.0), end: Offset.zero);
                  
                  Animation<Offset> slideAnimation = slideTween.animate(animation);
                  return SlideTransition(
                    position: slideAnimation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 1200), 
              );
            } else {
              return const MaterialPage(child: LoginScreen());
            }
          },
        ),
        GoRoute(
          path: '/',
          pageBuilder: (context, state) {
            if (state.extra == 'fromLogin') {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const WelcomeScreen(),
                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  
                  final Tween<double> scaleTween = Tween<double>(begin: 0.0, end: 1.0);
                  
                  Animation<double> scaleAnimation = scaleTween.animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeIn, 
                    ),
                  );
                  
                  return ScaleTransition(
                    scale: scaleAnimation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 1000), 
              );
            } else {
              return MaterialPage(
                key: state.pageKey,
                child: const WelcomeScreen());
            }
          },
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
