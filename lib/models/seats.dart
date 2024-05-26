import 'package:flutter/material.dart';

class Seat {
  final String id;
  final bool isHidden;
  final bool isOccupied;
  bool isSelected;

  Seat({
    required this.id,
    required this.isHidden,
    required this.isOccupied,
    this.isSelected = false,
  });
}

class SeatType {
  final String name;
  final Color color;

  const SeatType({
    required this.name,
    required this.color,
  });
}
const seatTypes = [
  SeatType(name: 'Disponible', color: Colors.grey),
  SeatType(name: 'Reservado', color: Color(0xFFE50914)),
  SeatType(name: 'Seleccionado', color: Colors.blue),
];
