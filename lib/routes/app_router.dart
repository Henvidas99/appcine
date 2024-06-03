
import 'package:go_router/go_router.dart';
import 'package:the_movie_data_base/screens/Tabs/tab_account_screen.dart';
import 'package:the_movie_data_base/screens/Tabs/tab_home_screen.dart';
import 'package:the_movie_data_base/screens/Tabs/tab_ticket_screen.dart';
import 'package:the_movie_data_base/screens/login/login_screen.dart';
import 'package:the_movie_data_base/screens/welcome/welcome_screen.dart';
//import 'package:navegation_app/presentation/screen/screens.dart';


final appRouter = GoRouter(
  initialLocation: '/login',

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