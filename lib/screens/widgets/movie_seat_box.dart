import 'package:flutter/material.dart';
import 'package:the_movie_data_base/models/seats.dart';
import 'package:the_movie_data_base/screens/widgets/screen_painter.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_data_base/provider/seat_selection_provider.dart';

class MovieSeatBox extends StatelessWidget {
  const MovieSeatBox({
    super.key,
    required this.seat,
    this.size = 30, 
  });

  final Seat seat;
  final double size; 

  @override
  Widget build(BuildContext context) {
    final seatSelectionProvider = Provider.of<SeatSelectionProvider>(context);
    final isSelected = seatSelectionProvider.selectedSeats.contains(seat.id);

    return GestureDetector(
      onTap: seat.isOccupied
                    ? null
                    : () {
                        seatSelectionProvider.toggleSeatSelection(seat.id);
                      },
      child: Container(
        width: size, 
        height: size, 
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue
              : seat.isOccupied
                  ? const Color(0xFFE50914)
                  : Colors.grey,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class MovieSeats extends StatelessWidget {
  const MovieSeats({
    super.key,
    required this.seats,
  });

  final List<Seat> seats;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top:8.0),
            child: Text(
              'Selecciona los Asientos',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
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
                  seats: seats.where((seat) => seat.id.startsWith('A')).toList(), 
                  rowCount: 3,
                  columnCount: 3,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: MovieSeatSection(
                  seats: seats.where((seat) => seat.id.startsWith('E')).toList(), 
                  rowCount: 3,
                  columnCount: 6,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: MovieSeatSection(
                  seats: seats.where((seat) => seat.id.startsWith('B')).toList(),
                  rowCount: 3,
                  columnCount: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: MovieSeatSection(
                  seats: seats.where((seat) => seat.id.startsWith('C')).toList(), 
                  rowCount: 3,
                  columnCount: 3,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: MovieSeatSection(
                  seats: seats.where((seat) => seat.id.startsWith('F')).toList(), 
                  rowCount: 3,
                  columnCount: 6,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: MovieSeatSection(
                  seats: seats.where((seat) => seat.id.startsWith('D')).toList(), 
                  rowCount: 3,
                  columnCount: 3,
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
    super.key,
    required this.seats,
    required this.rowCount,
    required this.columnCount,
  });

  final List<Seat> seats;
  final int rowCount;
  final int columnCount;

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
        childAspectRatio: 1,
      ),
      itemCount: rowCount * columnCount,
      itemBuilder: (_, index) {
        if (index >= seats.length) {
          return Container();
        }
        final seat = seats[index];
        return MovieSeatBox(
          seat: seat,
          size: 30,
        );
      },
    );
  }
}

class MovieSeatTypeLegend extends StatelessWidget {
  const MovieSeatTypeLegend({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLegendItem('Disponible', Colors.grey),
          _buildLegendItem('Reservado', const Color(0xFFE50914)),
          _buildLegendItem('Seleccionado', Colors.blue),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}