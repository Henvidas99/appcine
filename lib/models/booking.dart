
class Booking {
  final String userId;
  final String movieTitle;
  final String posterUrl;
  final String date;
  final String time;
  final double price;
  final int numTickets;
  final List<String> seats;

  const Booking({
    required this.userId,
    required this.movieTitle, 
    required this.posterUrl,
    required this.date,
    required this.time, 
    required this.price,
    required this.numTickets, 
    required this.seats,

  });
}