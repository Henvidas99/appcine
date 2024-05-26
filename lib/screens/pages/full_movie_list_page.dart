import 'package:flutter/material.dart';

class FullMovieListPage extends StatelessWidget {
  final String title;
  final List<dynamic> movieList;

  const FullMovieListPage({super.key, required this.title, required this.movieList});

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
       title: Text(title),
    ),
    body: GridView.count(
        crossAxisCount: 3, // Número de columnas en la cuadrícula
        mainAxisSpacing: 2.0, // Espacio entre las filas
        childAspectRatio: 0.7, // Relación de aspecto de cada elemento en la cuadrícula
        children: movieList.map<Widget>((item) {
          final backdropPath = item['backdrop_path'];
          String imageUrl = backdropPath != null
              ? 'https://image.tmdb.org/t/p/w500$backdropPath'
              : 'https://fotografias.antena3.com/clipping/cmsimages01/2019/05/29/9B89AC82-4176-4127-89A2-F38F13E0A84E/98.jpg';
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 4.0), // Padding interno para cada elemento
            child: GestureDetector(
              onTap: () => null, // _showMovieDetails(context, item),
              child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  color: Colors.black.withOpacity(0.6), // Fondo semitransparente para el texto
                  width: double.infinity, // Asegurar que el contenedor ocupe todo el ancho
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    item['title'] ?? item['name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true, // Permitir que el texto se ajuste a varias líneas si es necesario
                  ),
                ),
              ],
            ),
          ),
          ),
          );
        }).toList(),
      ),
  );
}

}