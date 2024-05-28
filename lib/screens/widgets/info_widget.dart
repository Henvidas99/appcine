import 'package:flutter/material.dart';


class MovieInfoWidget extends StatefulWidget {
  final dynamic movie;
  
  const MovieInfoWidget({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  _MovieInfoWidgetState createState() => _MovieInfoWidgetState();
}

class _MovieInfoWidgetState extends State<MovieInfoWidget> {
  bool _showFullOverview = false;

  @override
  Widget build(BuildContext context) {
    final String language = _getLanguageName(widget.movie['original_language']);
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Display the movie overview
      const Padding(
        padding: EdgeInsets.only(bottom: 8.0, top: 5.0),
        child: Text(
          'Descripción:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      _buildOverview(),
      // Display release date, duration, and rating
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoItem('Fecha de lanzamiento', widget.movie['release_date']),
            _buildInfoItem('Idioma', language),
            _buildInfoItem('Calificación', "${widget.movie['vote_average']}/10"),
          ],
        ),
      ),
    ],
  );
}

String _getLanguageName(String languageCode) {
  switch (languageCode) {
    case 'en':
      return 'Inglés';
    case 'fr':
      return 'Francés';
    default:
      return 'Inglés'; // Puedes agregar más casos según los idiomas que necesites
  }
}

Widget _buildOverview() {
  final String? overview = widget.movie['overview'];
  final bool hasValidOverview = overview != null && overview.isNotEmpty;
  final int maxOverviewLength = 225;
  final bool isTruncated = hasValidOverview && overview.length >= maxOverviewLength;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (hasValidOverview)
        Text(
          _showFullOverview
              ? overview
              : (isTruncated
                  ? '${overview.substring(0, maxOverviewLength)}...'
                  : overview),
          textAlign: TextAlign.justify,
        )
      else
        Text(
          'No hay descripción disponible.',
          textAlign: TextAlign.justify,
        ),
      if (isTruncated)
        TextButton(
          onPressed: () {
            setState(() {
              _showFullOverview = !_showFullOverview;
            });
          },
          child: Text(
            _showFullOverview ? 'Ver menos' : 'Ver más',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        )
      else
        const Padding(
          padding: EdgeInsets.only(top: 25.0), // Ajusta el valor del padding según sea necesario
        ),
    ],
  );
}





  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + ':',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(value),
      ],
    );
  }
}
