import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:the_movie_data_base/screens/pages/success_screen_page.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_data_base/provider/seat_selection_provider.dart';

class SummaryScreen extends StatelessWidget {
  final dynamic selectedMovie;
  final String selectedDate;
  final String selectedTime;
  final List<String> selectedSeats;

  const SummaryScreen({
    super.key,
    required this.selectedMovie,
    required this.selectedDate,
    required this.selectedTime, 
    required this.selectedSeats,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
         child: Stack(
        children: [
        Column(
          children:  [
            const SizedBox(height: 10),

            //Back icon and title
            const _BackIconRow(),

            const SizedBox(height: 10),


            TicketsSummaryBox(selectedMovie: selectedMovie, selectedDate: selectedDate, selectedTime: selectedTime, selectedSeats: selectedSeats,),

            ConfirmBookingsButton(
                  selectedMovie: selectedMovie,
                  selectedDate: selectedDate,
                  selectedTime: selectedTime,
                  selectedSeats: selectedSeats,
                ),

            
         
          ],
        ),
         Positioned(
            top: size.height * .628,
            left: 15,
            child: const Icon(Icons.circle, color: Color.fromRGBO(29, 29, 39, 1)),
          ),
          Positioned(
            top: size.height * .628,
            right: 15,
            child: const Icon(Icons.circle, color: Color.fromRGBO(29, 29, 39, 1)),
          ),
      ],
      
      ),
    ),
    );
  }
}


class _BackIconRow extends StatelessWidget {
  const _BackIconRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 15),
        InkResponse(
          radius: 25,
          child: const Icon(Icons.arrow_back_sharp, size: 26),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),

        const SizedBox(width: 110),

        //Title
        const Center(
          child: Text(
            'Ticket', style: TextStyle(fontSize: 20, ),
          ),
        ),

        const Spacer(),
      ],
    );
  }
}

class TicketsSummaryBox extends StatelessWidget {
  final dynamic selectedMovie;
  final String selectedDate;
  final String selectedTime;
  final List<String> selectedSeats;

  const TicketsSummaryBox({
    super.key,
    required this.selectedMovie,
    required this.selectedDate,
    required this.selectedTime, 
    required this.selectedSeats,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.78,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
                Container(
                    height: size.height * .40,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                      image: DecorationImage(
                        image: NetworkImage('https://image.tmdb.org/t/p/w500${selectedMovie['poster_path']}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
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
                      const SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(25, (index) => const Text('- ', style: TextStyle(color: Colors.grey))),
                  ),
                  const SizedBox(height: 5.0),
                  Center(
                    child: QrImageView(
                      data: 'Película: ${selectedMovie['title']}, Fecha: $selectedDate, Hora: $selectedTime, Asientos: $selectedSeats ',
                      version: QrVersions.auto,
                      size: 120.0,
                      gapless: false,
                    ),
                  ),
                ],
              ),
      ),  
      );
  }
}

class ConfirmBookingsButton extends StatelessWidget {
  final dynamic selectedMovie;
  final String selectedDate;
  final String selectedTime;
  final List<String> selectedSeats;

  const ConfirmBookingsButton({
    super.key,
    required this.selectedMovie,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedSeats,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
      child: ElevatedButton(
        onPressed: () {

          final seatSelectionProvider = Provider.of<SeatSelectionProvider>(context, listen: false);
          seatSelectionProvider.reserveSeats(selectedMovie['id'].toString(), selectedDate, selectedTime);

          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SuccessScreen()),
          );
        },
         style: ElevatedButton.styleFrom(
                  fixedSize: const Size.fromHeight(50),            
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
      ),
    );
  }
}