import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SummaryScreen extends StatelessWidget {
  final dynamic selectedMovie;
  final String selectedDate;
  final String selectedTime;
  final List<String> selectedSeats;

  const SummaryScreen({
    Key? key,
    required this.selectedMovie,
    required this.selectedDate,
    required this.selectedTime, 
    required this.selectedSeats,
  }) : super(key: key);

    Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;


    return Scaffold(
      backgroundColor: const Color(0xff21242C),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [
                    Container(
                      height: size.height * .45,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                        image: DecorationImage(
                          image: NetworkImage('https://image.tmdb.org/t/p/w500${selectedMovie['poster_path']}'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                          child: Column(
                            children: [
                              Text('Fecha', style: TextStyle(color: Colors.grey, fontSize: 16)),
                              Text(selectedDate),
                            ],
                          ),
                        ),
                        Expanded(
                         child: Column(
                            children: [
                              Text('TICKETES', style: TextStyle(color: Colors.grey, fontSize: 16)),
                              Text('${selectedSeats.length}'),
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
                              const Text('HORA', style: TextStyle(color: Colors.grey, fontSize: 16)),
                              Text(selectedTime),
                            ],
                          ),
                          ),
                          Expanded(
                          child: Column(
                             children: [
                              const Text('ASIENTOS', style: TextStyle(color: Colors.grey, fontSize: 16)),
                              Wrap(
                                children: List.generate(selectedSeats.length, (i) {
                                final isLastSeat = i == selectedSeats.length - 1;
                                  return Text(
                                    isLastSeat ? '${selectedSeats[i]}' : '${selectedSeats[i]}, ',
                                   );
                                }),
                              )
                            ],
                          ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(25, (index) => const Text('- ', style: TextStyle(color: Colors.grey))),
                    ),
                    const SizedBox(height: 5.0),
                    Center(
                      child: QrImageView(
                        data: 'Película: ${selectedMovie['title']}, Fecha: $selectedDate, Hora: $selectedTime, ',
                        version: QrVersions.auto,
                        size: 120.0,
                        gapless: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: size.height * .695,
              left: 15,
              child: const Icon(Icons.circle, color: Color(0xff21242C)),
            ),
            Positioned(
              top: size.height * .695,
              right: 15,
              child: const Icon(Icons.circle, color: Color(0xff21242C)),
            ),
          ],
        ),
      ),
    );
    }
}
