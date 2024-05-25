import 'package:flutter/material.dart';
import 'package:the_movie_data_base/services/api.service.dart';

Widget showMovieInfo(dynamic movie, bool showFullOverview) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Display the movie overview
      const Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Text(
          'Overview:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      _buildOverview(movie['overview'], showFullOverview),
      // Display release date, duration, and rating
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoItem('Release Date', movie['release_date']),
            _buildInfoItem('Duration', movie['runtime'].toString() + ' min'),
            _buildInfoItem('Rating', movie['vote_average'].toString()),
          ],
        ),
      ),
    ],
  );
}

Widget _buildOverview(String overview, bool showFullOverview) {
  final bool isTruncated = overview.length > 150;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        showFullOverview ? overview : (isTruncated ? '${overview.substring(0, 150)}...' : overview),
        textAlign: TextAlign.justify,
      ),
      if (isTruncated && !showFullOverview)
        TextButton(
          onPressed: () {
            // Handle the action to show full overview
            // You can implement this functionality based on your requirement
          },
          child: const Text('Show More'),
        ),
    ],
  );
}

Widget _buildInfoItem(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(value),
    ],
  );
}

Future<List<dynamic>> _getMovieCredits(dynamic movie) async {
  try {
    final ApiService apiService = ApiService();
    return await apiService.fetchMovieCredits(movie['id']);
  } catch (e) {
    print('Error fetching movie credits: $e');
    return []; // Devuelve una lista vacía en caso de error
  }
}

Widget showMovieCast(dynamic movie) {
  return FutureBuilder<List<dynamic>>(
    future: _getMovieCredits(movie),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: Text('Cargando...'));
      } else if (snapshot.hasError || snapshot.data == null) {
        return Text('Error loading movie credits');
      } else {
        final List<dynamic> credits = snapshot.data!;
        final List<dynamic>? cast = credits[0];
        final dynamic? director = credits[1];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (director != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Director: ${director}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            if (cast != null) ...[
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Cast:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cast.length,
                  itemBuilder: (context, index) {
                    final actor = cast[index];
                    return Padding(
                      padding: EdgeInsets.only(left: index > 0 ? 8.0 : 0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                actor['profile_path'] != null
                                    ? 'https://image.tmdb.org/t/p/w200${actor['profile_path']}'
                                    : 'https://via.placeholder.com/150',
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 80,
                            child: Text(
                              actor['name'],
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        );
      }
    },
  );
}
