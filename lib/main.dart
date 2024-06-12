import 'package:flutter/material.dart';
import 'package:the_movie_data_base/provider/account_provider.dart';
import 'package:the_movie_data_base/provider/booking_provider.dart';
import 'package:the_movie_data_base/provider/movies_provider.dart';
import 'package:the_movie_data_base/provider/seat_selection_provider.dart';
import 'package:the_movie_data_base/routes/app_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => SeatSelectionProvider()),
        ChangeNotifierProvider(create: (_) => MoviesProvider()),    
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context, listen: false);

    return MyRouter(accountProvider.isLoggedIn);
  }
}