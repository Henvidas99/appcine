
class Booking {
  final String movieTitle;
  final String posterUrl;
  final String date;
  final String time;
  final double price;
  final int numTickets;

  const Booking({
    required this.movieTitle, 
    required this.posterUrl,
    required this.date,
    required this.time, 
    required this.price,
    required this.numTickets,

  });
}