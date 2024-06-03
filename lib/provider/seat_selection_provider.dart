import 'package:flutter/material.dart';
import 'package:the_movie_data_base/models/seats.dart';

class SeatSelectionProvider with ChangeNotifier {
  final Map<String, Map<String, Map<String, List<Seat>>>> _movieSeatMap = {};
  final List<String> _selectedSeats = [];

  Map<String, Map<String, Map<String, List<Seat>>>> get movieSeatMap => _movieSeatMap;
  List<String> get selectedSeats => _selectedSeats;

  void initializeSeats(String movieId, String date, String time, List<Seat> seats) {
    _movieSeatMap.putIfAbsent(movieId, () => {});
    _movieSeatMap[movieId]!.putIfAbsent(date, () => {});
    _movieSeatMap[movieId]![date]!.putIfAbsent(time, () => seats);
  }

  List<Seat> getSeats(String movieId, String date, String time) {
    return _movieSeatMap[movieId]?[date]?[time] ?? [];
  }

  void toggleSeatSelection(String seatId) {
    if (_selectedSeats.contains(seatId) ) {
      _selectedSeats.remove(seatId);
    } else {
      _selectedSeats.add(seatId);
    }
    notifyListeners();
  }

  void clearSelectedSeats() {
    _selectedSeats.clear();
    notifyListeners();
  }

  void reserveSeats(String movieId, String date, String time) {
    List<Seat> seats = getSeats(movieId, date, time);
    for (var seat in seats) {
      if (_selectedSeats.contains(seat.id)) {
        seat.isOccupied = true;
      }
    }
    clearSelectedSeats();
    notifyListeners();
  }
}
