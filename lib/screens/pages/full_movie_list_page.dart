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
      crossAxisSpacing: 10.0, // Espacio entre las columnas
      childAspectRatio: 0.42, // Relación de aspecto de cada elemento en la cuadrícula (ajusta según tus necesidades)
      children: movieList.map<Widget>((item) {
        final backdropPath = item['backdrop_path'];
        String imageUrl = backdropPath != null
            ? 'https://image.tmdb.org/t/p/w500$backdropPath'
            : 'https://fotografias.antena3.com/clipping/cmsimages01/2019/05/29/9B89AC82-4176-4127-89A2-F38F13E0A84E/98.jpg';
        return GestureDetector(
          onTap: () =>null,// _showMovieDetails(context, item),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover, // Ajusta la imagen para que cubra todo el contenedor
                  height: 180, // Define la altura deseada para la imagen
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: SizedBox(
                  width: 150, // Ancho máximo permitido para el texto
                  child: Text(
                    item['title'] ?? item['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    softWrap: true, // Permitir que el texto se ajuste a varias líneas si es necesario
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}
}