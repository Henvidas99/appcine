import 'package:flutter/material.dart';
import 'package:the_movie_data_base/screens/widgets/movie_widgets.dart';
import 'package:the_movie_data_base/screens/widgets/trailer_widget.dart'; 

class MovieDetailPage extends StatefulWidget {
  final dynamic movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  // ignore: library_private_types_in_public_api
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final bool _showFullOverview = false;


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
    return showMovieInfo(widget.movie, _showFullOverview);
  }

  Future<Widget> _getMovieCast() async {
    // Implementa la lógica para obtener el elenco de la película de forma asíncrona
    // Por ejemplo, showMovieCast(widget.movie)
    return showMovieCast(widget.movie);
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _loadMovieDetails(),
        builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra el indicador de carga central mientras se cargan los datos
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading movie details: ${snapshot.error}'),
            );
          } else {
            // Una vez que se completan todos los futures, muestra los widgets
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  snapshot.data![0], // Trailer widget
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: snapshot.data![1], // Movie information
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: snapshot.data![2], // Movie cast
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Implementa la funcionalidad para comprar tiquetes
                      },
                      child: const Text('Comprar Tiquetes', style: TextStyle(fontSize: 18)),
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