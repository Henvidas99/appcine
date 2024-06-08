import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_movie_data_base/provider/account_provider.dart';
import 'dart:convert';

import 'package:the_movie_data_base/provider/booking_provider.dart';

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
  _TabAccountScreenState createState() => _TabAccountScreenState();
}

class _TabAccountScreenState extends State<TabAccountScreen> {
  Map<String, dynamic> _accountData = {};

  @override
  void initState() {
    super.initState();
    _loadAccountData();
  }

  Future<void> _loadAccountData() async {
    final accountData = await AccountService.getAccountData();
    setState(() {
      _accountData = accountData;
    });
  }

    ImageProvider<Object>? _getAvatarImage() {
    if (_accountData.containsKey('avatar') &&
        _accountData['avatar'] != null &&
        _accountData['avatar']['tmdb'] != null &&
        _accountData['avatar']['tmdb']['avatar_path'] != null) {
      final String avatarPath = _accountData['avatar']['tmdb']['avatar_path'];
      return NetworkImage('https://image.tmdb.org/t/p/w500$avatarPath');
    } else {
      return AssetImage('assets/logo.png');
    }
  }

 @override
  Widget build(BuildContext context) {
    final bookings = Provider.of<BookingProvider>(context).bookings;
    final account = Provider.of<AccountProvider>(context).accounts;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/fondo1.jpg'),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: account[0].avatar, 
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'ID: ${account[0].userId }',
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Nombre de usuario: ${account[0].username}',
                      style: const TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Nombre: ${account[0].name}',
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 179, 94, 94),
                ),
                child: const Center(
                  child: Text('Historial de reservas', style: TextStyle(fontSize: 20)),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: bookings.length,
                  separatorBuilder: (_, i) => const SizedBox(height: 20),
                  itemBuilder: (_, i) {
                    final booking = bookings[bookings.length - 1 - i]; // Accede a los elementos en orden inverso
                    final imageUrl = booking.posterUrl;
                    return Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: BookingSummaryRow(
                        title: booking.movieTitle,
                        poster: 'https://image.tmdb.org/t/p/w500$imageUrl',
                        dateTime: '${booking.date}, ${booking.time}',
                        totalPrice: booking.price,
                        noOfTickets: booking.numTickets,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
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
                    color: Color.fromRGBO(173, 150, 150, 0.965),
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