import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_movie_data_base/models/booking.dart';
import 'package:the_movie_data_base/provider/account_provider.dart';
import 'package:the_movie_data_base/provider/booking_provider.dart';
import 'package:the_movie_data_base/screens/pages/success_screen_page.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_data_base/provider/seat_selection_provider.dart';

class SummaryScreen extends StatelessWidget {
  final dynamic selectedMovie;
  final dynamic selectedMoviePoster;
  final dynamic selectedMovieTitle;
  final String selectedDate;
  final String selectedTime;
  final List<String> selectedSeats;

  const SummaryScreen({
    super.key,
    this.selectedMoviePoster,
    required this.selectedDate,
    required this.selectedTime, 
    required this.selectedSeats, 
    this.selectedMovieTitle, 
    this.selectedMovie,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;
    final numTickets = selectedSeats.length;

   
    return Scaffold(
      appBar: AppBar(
         toolbarHeight: size *0.06,
         title: const Center(
          child: Text(
            'Ticket', style: TextStyle(fontSize: 20, ),
          ),
        ),

      ),
      body: SingleChildScrollView(
        child: SafeArea(
           child: Stack(
          children: [
          Column(
            children:  [
              SizedBox(
                height: size * 0.80,
                child: TicketsSummaryBox(selectedMoviePoster: selectedMoviePoster, selectedMovieTitle: selectedMovieTitle, selectedDate: selectedDate, selectedTime: selectedTime, selectedSeats: selectedSeats,),
              ),
              if(selectedMovie != null)
              SizedBox(height: 60,
                child: ConfirmBookingsButton(        
                    selectedMovie: selectedMovie,
                    selectedDate: selectedDate,
                    selectedTime: selectedTime,
                    tickets: numTickets,
                    selectedSeats: selectedSeats,
                  ),
              )     
            ],
          ),
           Positioned(
              top: size * .556,
              left: 15,
              child: const Icon(Icons.circle, color: Color.fromRGBO(29, 29, 39, 1)),
            ),
            Positioned(
              top: size * .556,
              right: 15,
              child: const Icon(Icons.circle, color: Color.fromRGBO(29, 29, 39, 1)),
            ),
        ],
        
        ),
            ),
      ),
    );
  }
}


class TicketsSummaryBox extends StatelessWidget {
  final dynamic selectedMoviePoster;
  final dynamic selectedMovieTitle;
  final String selectedDate;
  final String selectedTime;
  final List<String> selectedSeats;

  const TicketsSummaryBox({
    super.key,
    required this.selectedMoviePoster,
    required this.selectedDate,
    required this.selectedTime, 
    required this.selectedSeats, 
    required this.selectedMovieTitle,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:30.0,vertical: 20.0 ),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: [
                  Container(
                      height: (size.height - 40) * 0.40,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                        image: DecorationImage(
                          image: NetworkImage('https://image.tmdb.org/t/p/w500$selectedMoviePoster'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),            
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Center(child: Text('Fecha', style: TextStyle(color: Colors.grey, fontSize: 16))),
                                Text(selectedDate, style: const TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text('TICKETES', style: TextStyle(color: Colors.grey, fontSize: 16)),
                                Text('${selectedSeats.length}', style: const TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Center(child: Text('HORA', style: TextStyle(color: Colors.grey, fontSize: 16))),
                              Text(selectedTime, style: const TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                        Expanded(
                         child: Column(
                          children: [
                          const Text(
                            'ASIENTOS', 
                            style: TextStyle(color: Colors.grey, fontSize: 16)
                            ),
                          Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              selectedSeats.join(', '), 
                              style: const TextStyle(
                              color: Color.fromARGB(255, 15, 13, 13)
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1, 
                            softWrap: false, 
                            ),
                          ),
                        ],
                        )
                        ),
                      ],
                    ),
                    Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Dash(
                      direction: Axis.horizontal,
                      length: size.width - 60,
                      dashLength: 5,
                      dashGap: 3,
                      dashColor: const Color.fromARGB(255, 85, 67, 67),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: QrImageView(
                        data: 'Película: $selectedMovieTitle, Fecha: $selectedDate, Hora: $selectedTime, Asientos: $selectedSeats ',
                        version: QrVersions.auto,
                        size: (size.height - 80) * 0.20,
                        gapless: false,
                      ),
                    ),
                  ),
                  ],
                ),
        ),
    );
  }
}

class ConfirmBookingsButton extends StatefulWidget {
  final dynamic selectedMovie;
  final String selectedDate;
  final String selectedTime;
  final int tickets;
  final List<String> selectedSeats;

  const ConfirmBookingsButton({
    super.key,
    required this.selectedMovie,
    required this.selectedDate,
    required this.selectedTime,
    required this.tickets, 
    required this.selectedSeats,
  });


  @override
  // ignore: library_private_types_in_public_api
  _ConfirmBookingButtonState createState() => _ConfirmBookingButtonState();

}
  class _ConfirmBookingButtonState extends State<ConfirmBookingsButton> {
    List<String> seats = [];

    @override
  void initState() {
    super.initState();
    getSeats();
  }

  Future<void> getSeats() async {
    final prefs = await SharedPreferences.getInstance();
    final savedSeats =  prefs.getStringList('selectedSeats');
    setState(() {
          seats = savedSeats ?? [];
    });

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ElevatedButton(
        onPressed: () {
           final seatSelectionProvider = Provider.of<SeatSelectionProvider>(context, listen: false);
          seatSelectionProvider.reserveSeats(widget.selectedMovie['id'].toString(), widget.selectedDate, widget.selectedTime);

          final account = Provider.of<AccountProvider>(context, listen: false).accounts;
          final id = account[0].userId;

          final booking = Booking(
            userId: id,
            movieTitle: widget.selectedMovie['title'],
            posterUrl: widget.selectedMovie['poster_path'],
            date: widget.selectedDate,
            time: widget.selectedTime,
            price: widget.tickets * 5000,
            numTickets: widget.tickets,
            seats: seats,
          );

           final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
           bookingProvider.addBooking(booking);


          

          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SuccessScreen()),
          );
        },
         style: ElevatedButton.styleFrom(
                  fixedSize: Size(size.width.toInt() -60, 0),         
                  backgroundColor: const Color(0xFFE50914),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
            ),
         ),
        child: const Center(
          child: Text(
            'CONFIRMAR',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              letterSpacing: 0.7,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

    );
  }

  
}