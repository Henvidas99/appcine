import 'package:flutter/material.dart';
import 'package:the_movie_data_base/screens/Tabs/tab_ticket_screen.dart';
import 'package:the_movie_data_base/screens/widgets/credit_widget.dart';
import 'package:the_movie_data_base/screens/widgets/genre_list_widget.dart';
import 'package:the_movie_data_base/screens/widgets/info_widget.dart';
import 'package:the_movie_data_base/screens/widgets/trailer_widget.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_data_base/provider/seat_selection_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';

class MovieDetailPage extends StatefulWidget {
  final dynamic movie;
  final bool showButton;
  final List<String> genreList;

  const MovieDetailPage({
    super.key,
    required this.movie,
    this.showButton = false,
    required this.genreList,
  });

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late Widget _trailerWidget;

  @override
  void initState() {
    super.initState();
    _trailerWidget = TrailerWidget(movie: widget.movie);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: size * 0.30), // Padding para el espacio del trailer
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GenreList(chipContents: widget.genreList),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FutureBuilder(
                      future: _getMovieInfo(),
                      builder: (context, AsyncSnapshot<Widget> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error loading movie info: ${snapshot.error}'));
                        } else {
                          return snapshot.data!;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FutureBuilder(
                      future: _getMovieCast(),
                      builder: (context, AsyncSnapshot<Widget> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error loading movie cast: ${snapshot.error}'));
                        } else {
                          return snapshot.data!;
                        }
                      },
                    ),
                  ),
                  if (widget.showButton == true)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.scale,
                              reverseDuration: const Duration(milliseconds: 500),
                              alignment: Alignment.bottomCenter,
                              duration: const Duration(milliseconds: 500),
                              child: TabTicketScreen(selectedMovie: widget.movie, band: true),
                            ),
                          );
                          Provider.of<SeatSelectionProvider>(context, listen: false).clearSelectedSeats();
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromHeight(50),
                          backgroundColor: const Color(0xFFE50914),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        child: Text('Reservar Tiquetes', 
                          style: GoogleFonts.oswald(
                            textStyle: const TextStyle( fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size * 0.30, // Altura fija para el tráiler
            child: _trailerWidget,
          ),
          Positioned(
              top: 40,
              left: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.5), 
                  ),
                  padding: const EdgeInsets.all(8), 
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<Widget> _getMovieInfo() async {
    return MovieInfoWidget(movie: widget.movie);
  }

  Future<Widget> _getMovieCast() async {
    return CreditsWidget(movie: widget.movie);
  }
}
