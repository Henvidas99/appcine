import 'package:flutter/material.dart';
import 'package:the_movie_data_base/screens/Tabs/tab_ticket_screen.dart';
import 'package:the_movie_data_base/screens/widgets/credit_widget.dart';
import 'package:the_movie_data_base/screens/widgets/info_widget.dart';
import 'package:the_movie_data_base/screens/widgets/trailer_widget.dart'; 

class MovieDetailPage extends StatefulWidget {
  final dynamic movie;

  const MovieDetailPage({super.key, required this.movie});

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
    // Implementa la lógica para obtener el trailer de la película de forma asíncrona
    // Por ejemplo, TrailerWidget(movie: widget.movie)
    return TrailerWidget(movie: widget.movie);
  }

  Future<Widget> _getMovieInfo() async {
    // Implementa la lógica para obtener la información de la película de forma asíncrona
    // Por ejemplo, showMovieInfo(widget.movie, _showFullOverview)
    return MovieInfoWidget(movie:widget.movie);
  }

  Future<Widget> _getMovieCast() async {
    // Implementa la lógica para obtener el elenco de la película de forma asíncrona
    // Por ejemplo, showMovieCast(widget.movie)
    return CreditsWidget(movie:widget.movie);
  }

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

            return Stack(
              children: [
                // Este SingleChildScrollView contendrá el resto del contenido.
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(top: 200), // Ajusta 300 según la altura del tráiler
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: snapshot.data![1], // Movie information
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: snapshot.data![2], // Movie cast
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                              MaterialPageRoute(
                              builder: (context) => TabTicketScreen(selectedMovie: widget.movie),
                              ),
                            );
                            },
                            child: const Text('Comprar Tiquetes', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Este contenedor contendrá el tráiler y permanecerá fijo en la parte superior.
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Stack(
                    children: [
                      Container(
                        child: snapshot.data![0], // Trailer widget
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
                ),
              ],
            );
          }
        },
      ),
    );
  }

}