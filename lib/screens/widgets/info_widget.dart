import 'package:flutter/material.dart';


class MovieInfoWidget extends StatefulWidget {
  final dynamic movie;
  
  const MovieInfoWidget({
    super.key,
    required this.movie,
  });

  @override
  // ignore: library_private_types_in_public_api
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
      const Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Text(
          'Descripción:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      _buildOverview(),
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
      return 'Inglés'; 
  }
}

Widget _buildOverview() {
  final String? overview = widget.movie['overview'];
  final bool hasValidOverview = overview != null && overview.isNotEmpty;
  const int maxOverviewLength = 225;
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
        const Text(
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
          padding: EdgeInsets.only(top: 15.0),
        ),
    ],
  );
}





  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(value),
      ],
    );
  }
}
