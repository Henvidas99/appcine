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
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Display the movie overview
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
      // Display release date, duration, and rating
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoItem('Fecha de lanzamiento', widget.movie['release_date']),
            _buildInfoItem('Idioma', widget.movie['original_language']),
            _buildInfoItem('Calificación', "${widget.movie['vote_average']}/10"),
          ],
        ),
      ),
    ],
  );
}

  Widget _buildOverview() {
    final bool isTruncated = widget.movie['overview'].length > 150;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _showFullOverview
              ? widget.movie['overview']
              : (isTruncated
                  ? '${widget.movie['overview'].substring(0, 150)}...'
                  : widget.movie['overview']),
          textAlign: TextAlign.justify,
        ),
        if (isTruncated)
          TextButton(
            onPressed: () {
              setState(() {
                _showFullOverview = !_showFullOverview;
              });
            },
            child: Text(_showFullOverview ? 'Ver menos' : 'Ver más'),
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
