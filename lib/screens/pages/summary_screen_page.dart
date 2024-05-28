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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
         child: Stack(
        children: [
        Column(
          children:  [
            SizedBox(height: 10),

            //Back icon and title
            _BackIconRow(),

            SizedBox(height: 10),

            //Tickets Box
            TicketsSummaryBox(selectedMovie: selectedMovie, selectedDate: selectedDate, selectedTime: selectedTime, selectedSeats: selectedSeats,),

            //Confirm Button
            ConfirmBookingsButton(),

            
         
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


/*
 Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;

  return Scaffold(
    backgroundColor: const Color(0xff21242C),
    body: SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
            child: Container(
              height: size.height * .80,
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
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
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text('Fecha', style: TextStyle(color: Colors.grey, fontSize: 16)),
                              Text(selectedDate, style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text('TICKETES', style: TextStyle(color: Colors.grey, fontSize: 16)),
                              Text('${selectedSeats.length}', style: TextStyle(color: Colors.black)),
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
                            Text(selectedTime, style: TextStyle(color: Colors.black)),
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
                                  style: TextStyle(color: Colors.black),
                                );
                              }),
                            ),
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
            top: size.height * .680,
            left: 15,
            child: const Icon(Icons.circle, color: Color(0xff21242C)),
          ),
          Positioned(
            top: size.height * .680,
            right: 15,
            child: const Icon(Icons.circle, color: Color(0xff21242C)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(top: size.height * 0.6),
              child: ElevatedButton(
                onPressed: () {
                  // Acción del botón
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size.fromHeight(50),
                  backgroundColor: const Color(0xFFE50914),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'CompKrar Tiquetes',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
*/



class _BackIconRow extends StatelessWidget {
  const _BackIconRow({Key? key}) : super(key: key);

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
    Key? key,
    required this.selectedMovie,
    required this.selectedDate,
    required this.selectedTime, 
    required this.selectedSeats,
  }) : super(key: key);

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
                              Center(child: Text('Fecha', style: TextStyle(color: Colors.grey, fontSize: 16))),
                              Text(selectedDate, style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text('TICKETES', style: TextStyle(color: Colors.grey, fontSize: 16)),
                              Text('${selectedSeats.length}', style: TextStyle(color: Colors.black)),
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
                            Center(child: const Text('HORA', style: TextStyle(color: Colors.grey, fontSize: 16))),
                            Text(selectedTime, style: TextStyle(color: Colors.black)),
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
                                  style: TextStyle(color: Colors.black),
                                );
                              }),
                            ),
                          ]
                        ),
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
                      data: 'Película: ${selectedMovie['title']}, Fecha: $selectedDate, Hora: $selectedTime, ',
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
  const ConfirmBookingsButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
      child: ElevatedButton(
        onPressed: () {
          
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
