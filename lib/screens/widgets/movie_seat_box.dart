import 'package:flutter/material.dart';
import 'package:the_movie_data_base/models/seats.dart';
import 'package:the_movie_data_base/screens/widgets/screen_painter.dart';

class MovieSeatBox extends StatelessWidget {
  const MovieSeatBox({
    Key? key,
    required this.seat,
    this.size = 30, // Añadido un parámetro de tamaño por defecto
  }) : super(key: key);

  final Seat seat;
  final double size; // Añadido un parámetro de tamaño

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, // Usar el parámetro de tamaño
      height: size, // Usar el parámetro de tamaño
      decoration: BoxDecoration(
        color: seat.isSelected ? Colors.blue: seat.isOccupied ? Colors.green  : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class MovieSeats extends StatelessWidget {
  const MovieSeats({
    Key? key,
    required this.seats,
    required this.onSeatSelected,
  }) : super(key: key);

  final List<List<Seat>> seats;
  final VoidCallback onSeatSelected;


  static List<String> getSelectedSeats(List<List<Seat>> seats) {
    List<String> selectedSeats = [];
    for (var row in seats) {
      for (var seat in row) {
        if (seat.isSelected) {
          selectedSeats.add(seat.id);
        }
      }
    }
    return selectedSeats;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: const Text(
              'Selecciona los Asientos',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                ),
              ),
          ),
             Padding(
               padding: const EdgeInsets.only(top: 8.0),
               child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: CustomPaint(
                  painter: ScreenPainter(),
                ),
              ),
             ),
            const SizedBox(height:20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: MovieSeatSection(
                  seats: seats[0], // Sección A
                  rowCount: 3,
                  columnCount: 3,
                  onSeatSelected: onSeatSelected,
                  seatSize: 30,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: MovieSeatSection(
                  seats: seats[4], // Sección E
                  rowCount: 3,
                  columnCount: 6,
                  onSeatSelected: onSeatSelected,
                  seatSize: 40, // Tamaño más grande para la sección central
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: MovieSeatSection(
                  seats: seats[1], // Sección C
                  rowCount: 3,
                  columnCount: 3,
                  onSeatSelected: onSeatSelected,
                  seatSize: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Fila inferior: Secciones B, D, F
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: MovieSeatSection(
                  seats: seats[2], // Sección B
                  rowCount: 3,
                  columnCount: 3,
                  onSeatSelected: onSeatSelected,
                  seatSize: 30,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: MovieSeatSection(
                  seats: seats[5], // Sección D
                  rowCount: 3,
                  columnCount: 6,
                  onSeatSelected: onSeatSelected,
                  seatSize: 40, // Tamaño más grande para la sección central
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: MovieSeatSection(
                  seats: seats[3], // Sección F
                  rowCount: 3,
                  columnCount: 3,
                  onSeatSelected: onSeatSelected,
                  seatSize: 30,
                ),
              ),
            ],
          ),
          const Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: MovieSeatTypeLegend(),
          ),
        ],
      ),
    );
  }
}

class MovieSeatSection extends StatelessWidget {
  const MovieSeatSection({
    Key? key,
    required this.seats,
    required this.rowCount,
    required this.columnCount,
    required this.onSeatSelected,
    this.seatSize = 30, // Añadido un parámetro de tamaño por defecto
  }) : super(key: key);

  final List<Seat> seats;
  final int rowCount;
  final int columnCount;
  final VoidCallback onSeatSelected;
  final double seatSize; // Añadido un parámetro de tamaño

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1, // Mantener el aspecto cuadrado
      ),
      itemCount: rowCount * columnCount,
      itemBuilder: (_, index) {
        if (index >= seats.length) {
          return Container(); // Asegurar que el índice no supere el tamaño de la lista de asientos
        }
        final seat = seats[index];
        return GestureDetector(
          onTap: () {
            seat.isSelected = !seat.isSelected;
            onSeatSelected();
          },
          child: MovieSeatBox(
            seat: seat,
            size: seatSize, // Usar el parámetro de tamaño
          ),
        );
      },
    );
  }
}



class MovieSeatTypeLegend extends StatelessWidget {
  const MovieSeatTypeLegend({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: seatTypes.map(
          (seatType) {
            return Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 12,
                    width: 12,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: seatType.color,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: Text(seatType.name, style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            );
          },
        ).toList(growable: false),
      ),
    );
  }


}













/*
class MovieSeatBox extends StatelessWidget {
  const MovieSeatBox({
    Key? key,
    required this.seat,
  }) : super(key: key);

  final Seat seat;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: seat.isSelected ? Colors.green : seat.isOccupied ? Colors.red : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}



class MovieSeats extends StatelessWidget {
  const MovieSeats({
    Key? key,
    required this.seats,
    required this.onSeatSelected, // Nueva propiedad
  }) : super(key: key);

  final List<List<Seat>> seats;
  final VoidCallback onSeatSelected; // Nueva propiedad

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            for (int i = 0; i < 3; i++)
              MovieSeatSection(
                seats: seats[i],
                isFront: true,
                onSeatSelected: onSeatSelected, // Pasamos la función a las secciones
              ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            for (int i = 3; i < 6; i++)
              MovieSeatSection(
                seats: seats[i],
                onSeatSelected: onSeatSelected, // Pasamos la función a las secciones
              ),
          ],
        ),
      ],
    );
  }
}

class MovieSeatTypeLegend extends StatelessWidget {
  const MovieSeatTypeLegend({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: seatTypes.map(
          (seatType) {
            return Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 12,
                    width: 12,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: seatType.color,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: Text(seatType.name),
                  ),
                ],
              ),
            );
          },
        ).toList(growable: false),
      ),
    );
  }
}



class MovieSeatSection extends StatelessWidget {
  const MovieSeatSection({
    Key? key,
    required this.seats,
    this.isFront = false,
     required this.onSeatSelected
  }) : super(key: key);

  final List<Seat> seats;
  final bool isFront;
  final VoidCallback onSeatSelected;

  @override
  Widget build(BuildContext context) {
    // Determina el número correcto de asientos a mostrar
    final itemCount = isFront ? 10 : 10;
    
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (_, index) {
          final seat = seats[index];
           return GestureDetector(
            onTap: () {
              seat.isSelected = !seat.isSelected;
              onSeatSelected();
            },
            child: MovieSeatBox(seat: seat),
          );
        },
      ),
    );
  }
}
*/