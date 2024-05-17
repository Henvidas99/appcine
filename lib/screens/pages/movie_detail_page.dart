import 'package:flutter/material.dart';
import 'package:the_movie_data_base/screens/widgets/movie_widgets.dart';
import 'package:the_movie_data_base/screens/widgets/trailer_widget.dart'; 

class MovieDetailPage extends StatelessWidget {
  final dynamic movie;

  const MovieDetailPage({Key? key, required this.movie}) : super(key: key);
  final bool _showFullOverview = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _loadMovieDetails(),
        builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra el indicador de carga central mientras se cargan los datos
            return Center(child: CircularProgressIndicator());
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
                      child: Text('Comprar Tiquetes', style: TextStyle(fontSize: 18)),
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

  // Métodos para cargar los detalles de la película de forma asíncrona
  Future<List<Widget>> _loadMovieDetails() async {
    // Cargar el tráiler de la película
    final Widget trailerWidget = await _getTrailer();
    // Cargar la información de la película
    final Widget movieInfoWidget = await _getMovieInfo();
    // Cargar el elenco de la película
    final Widget movieCastWidget = await _getMovieCast();

    // Devolver una lista con los widgets cargados
    return [trailerWidget, movieInfoWidget, movieCastWidget];
  }

  // Método para cargar el tráiler de la película de forma asíncrona
  Future<Widget> _getTrailer() async {
    // Implementa la lógica para obtener el tráiler de la película de forma asíncrona
    return TrailerWidget(movie: movie);
  }

  // Método para cargar la información de la película de forma asíncrona
  Future<Widget> _getMovieInfo() async {
    // Implementa la lógica para obtener la información de la película de forma asíncrona
    return showMovieInfo(movie, _showFullOverview);
  }

  // Método para cargar el elenco de la película de forma asíncrona
  Future<Widget> _getMovieCast() async {
    // Implementa la lógica para obtener el elenco de la película de forma asíncrona
    return showMovieCast(movie);
  }
}
