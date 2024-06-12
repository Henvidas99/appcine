import 'package:flutter/material.dart';
import 'package:the_movie_data_base/screens/Tabs/tab_ticket_screen.dart';
import 'package:the_movie_data_base/screens/widgets/credit_widget.dart';
import 'package:the_movie_data_base/screens/widgets/genre_list_widget.dart';
import 'package:the_movie_data_base/screens/widgets/info_widget.dart';
import 'package:the_movie_data_base/screens/widgets/trailer_widget.dart'; 
import 'package:provider/provider.dart';
import 'package:the_movie_data_base/provider/seat_selection_provider.dart';

class MovieDetailPage extends StatefulWidget {
  final dynamic movie;
  final bool showButton;
  final List<String> genreList;

  const MovieDetailPage({super.key, required this.movie, this.showButton =false, required this.genreList});

  @override
  // ignore: library_private_types_in_public_api
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {

  @override
  void initState() {
    super.initState();
  }

  Future<List<Widget>> _loadMovieDetails() async {
    final trailerWidget = await _getTrailer();
    final movieInfoWidget = await _getMovieInfo();
    final movieCastWidget = await _getMovieCast();

    return [trailerWidget, movieInfoWidget, movieCastWidget];
  }

  Future<Widget> _getTrailer() async {
    return TrailerWidget(movie: widget.movie);
  }

  Future<Widget> _getMovieInfo() async {
    return MovieInfoWidget(movie:widget.movie);
  }

  Future<Widget> _getMovieCast() async {
    return CreditsWidget(movie:widget.movie);
  }

  @override
  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: FutureBuilder(
      future: _loadMovieDetails(),
      builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading movie details: ${snapshot.error}'),
          );
        } else {
          return SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        Container(
                          child: snapshot.data![0],
                        ),
                      ],
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: GenreList(chipContents: widget.genreList),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: snapshot.data![1],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: snapshot.data![2],
                          ),
                          if (widget.showButton == true)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TabTicketScreen(selectedMovie: widget.movie),
                                    ),
                                  );
                                  Provider.of<SeatSelectionProvider>(context, listen: false).clearSelectedSeats();
                                },
                                style: ElevatedButton.styleFrom(
                                    fixedSize: const Size.fromHeight(50),
                                    backgroundColor: const Color(0xFFE50914),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: const Text('Reservar Tiquetes', style: TextStyle(fontSize: 18, color: Colors.white)),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
                Positioned(
                      top: 30,
                      child: BackButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
              ],            
            ),
          );
        }
      },
    ),
  );
}


}