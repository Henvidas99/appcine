import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_movie_data_base/models/booking.dart';
import 'package:the_movie_data_base/provider/account_provider.dart';
import 'dart:convert';
import 'package:the_movie_data_base/provider/booking_provider.dart';
import 'package:the_movie_data_base/screens/pages/summary_screen_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';


class AccountService {
  static const String _keyAccountData = 'accountData';

  static Future<Map<String, dynamic>> getAccountData() async {
    final prefs = await SharedPreferences.getInstance();
    final accountDataString = prefs.getString(_keyAccountData);
    if (accountDataString != null) {
      return json.decode(accountDataString);
    } else {
      return {}; 
    }
  }
}

class TabAccountScreen extends StatefulWidget {
  const TabAccountScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TabAccountScreenState createState() => _TabAccountScreenState();
}

class _TabAccountScreenState extends State<TabAccountScreen> {
  DateTime? lastPressed;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(interceptor);
  }

  @override
  void dispose() {
    super.dispose();
    BackButtonInterceptor.remove(interceptor);
  }

  bool interceptor(bool btnEvent, RouteInfo info) {
    if (BackButtonInterceptor.getCurrentNavigatorRouteName(context) != '/') return false;
    final now = DateTime.now();
    if (lastPressed == null || now.difference(lastPressed!) > const Duration(seconds: 3)) {
      lastPressed = now;
      final snackBar = SnackBar(
        backgroundColor: Colors.blueGrey,
        margin: const EdgeInsets.only(bottom: 60.0, left: 40, right: 40),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
          ),
          child: const Center(
            child: Text(
              'Presiona nuevamente para salir',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return true;
    }
    return false;
  }


  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('¿Estás seguro de que deseas cerrar sesión?',
            style: GoogleFonts.oswald(
              textStyle: const TextStyle( fontSize: 18, fontWeight: FontWeight.normal,color: Colors.white, ),),),
          backgroundColor: Colors.grey,

          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar', style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FilledButton(
              style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xFFE50914))),
              child: const Text('Cerrar sesión',style: TextStyle(color:Colors.white)),
              onPressed: () {
                _logout();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    final accountProvider = Provider.of<AccountProvider>(context, listen: false);
    accountProvider.removeAccount();
    context.pushReplacement('/login', extra: 'fromLogout');
  }

  @override
  Widget build(BuildContext context) {
  final bookings = Provider.of<BookingProvider>(context).bookings;
  final account = Provider.of<AccountProvider>(context).accounts;
  final assetImage = Provider.of<AccountProvider>(context).image;
  List<Booking> userBookings;

  if(account.isNotEmpty){
    userBookings = bookings.where((booking) => booking.userId == account[0].userId).toList();
  }

  else{
    userBookings =[];
  }

  return Scaffold(
    body: Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: assetImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: account.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Column(
                          children: [
                            Text('Mi Perfil', style: TextStyle(fontSize: 16),),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: account[0].avatar,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    'Usuario',
                                    style: GoogleFonts.oswald(
                                    textStyle: const TextStyle( fontSize: 16, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 229, 0, 0), ),
                                    ),
                                  ),
                                  Text(
                                    account[0].username,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                    Text(
                                    'Nombre',
                                    style: GoogleFonts.oswald(
                                    textStyle: const TextStyle( fontSize: 16, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 229, 0, 0), ),
                                  ),
                                  ),
                                  Text(
                                    account[0].name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const Center(
                      child: Text(
                        'No hay datos de la cuenta disponibles',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ),
             Padding(
               padding: const EdgeInsets.only(top:8.0),
               child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(155, 0, 0, 0.4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Historial de reservas',
                    style: GoogleFonts.oswald(
                      textStyle: const TextStyle( fontSize: 22, fontWeight: FontWeight.bold ),
                    ),
                  ),
                ),
              ),
             ),
             Expanded(
                child: userBookings.isNotEmpty
                    ? ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: userBookings.length,
                        separatorBuilder: (_, i) => const SizedBox(height: 20),
                        itemBuilder: (_, i) {
                          final booking = userBookings[userBookings.length - 1 - i];
                          final seats = booking.seats;
                          final imageUrl = booking.posterUrl;
                          return Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.scale,
                                    reverseDuration: const Duration(milliseconds: 500),
                                    alignment: Alignment.bottomCenter,
                                    duration: const Duration(milliseconds: 500),
                                    child:SummaryScreen(
                                      selectedMovieTitle: booking.movieTitle,
                                      selectedMoviePoster: booking.posterUrl,
                                      selectedDate: booking.date,
                                      selectedTime: booking.time,
                                      selectedSeats: seats,
                                    ),
                                  ),
                                );
                              },
                              child: BookingSummaryRow(
                                title: booking.movieTitle,
                                poster: 'https://image.tmdb.org/t/p/w500$imageUrl',
                                dateTime: '${booking.date}, ${booking.time}',
                                totalPrice: booking.price,
                                noOfTickets: booking.numTickets,
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_busy,
                              size: 80,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'No tienes reservas.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Empieza a explorar y hacer reservas.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ),
              ],
            ),
            Positioned(
              top: 38,
              right: 10,
              child: IconButton(
                onPressed: _confirmLogout,
                icon: const Icon(Icons.logout),
            ),
        )
      ],
    ),
  );
}
}

class BookingSummaryRow extends StatelessWidget {
  final String title;
  final String poster;
  final String dateTime;
  final double totalPrice;
  final int noOfTickets;

  const BookingSummaryRow({
    super.key,
    required this.title,
    required this.poster,
    required this.dateTime,
    required this.totalPrice,
    required this.noOfTickets,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Ticket total and movie name
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(117, 102, 102, 0.8),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(115, 10, 5, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Movie data
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      // Show timings row
                      Row(
                        children: [
                          // Show date icon
                          const Icon(
                            Icons.date_range_outlined,
                            size: 19,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 10),
                          // Show time data
                          Text(
                            dateTime,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Show payment row
                      Row(
                        children: [
                          // Total icon
                          const Icon(
                            Icons.local_atm_outlined,
                            size: 19,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 10),
                          // Total data
                          Text(
                            '₡ $totalPrice',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // No of seats
              SizedBox(
                height: double.infinity,
                width: 45,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFFf03400), Color(0xFFed0000)]),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Ticket icon
                      const Icon(
                        Icons.local_activity_sharp,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 5),
                      // No. of seats
                      Text(
                        '$noOfTickets',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 10,
            top: -25,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                poster,
                width: 95,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
