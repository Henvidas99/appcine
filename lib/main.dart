import 'package:flutter/material.dart';
import 'package:the_movie_data_base/provider/movies_provider.dart';
import 'package:the_movie_data_base/provider/seat_selection_provider.dart';
import 'package:the_movie_data_base/routes/app_router.dart';
import 'package:the_movie_data_base/styles/theme_data.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SeatSelectionProvider()),
        ChangeNotifierProvider(create: (_) => MoviesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: appTheme(),

    );
  }
}