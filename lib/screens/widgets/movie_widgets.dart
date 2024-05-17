import 'package:flutter/material.dart';
import 'package:the_movie_data_base/services/api.service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

Widget showTrailer(dynamic movie) {
  return FutureBuilder<String?>(
    future: _getTrailerKey(movie),
    builder: (context, snapshot) {
      if (snapshot.hasError || snapshot.data == null) {
        // Maneja el caso de error o si no hay tráiler disponible
        return _showNoTrailerDialog();
      } else {
        // Muestra el tráiler si está disponible
        return _showTrailerDialog(snapshot.data!);
      }
    },
  );
}

Future<String?> _getTrailerKey(dynamic movie) async {
  try {
    final ApiService apiService = ApiService();
    return await apiService.fetchTrailerKey(movie['id']);
  } catch (e) {
    print('Error fetching trailer key: $e');
    return null;
  }
}

Widget showMovieInfo(dynamic movie, bool showFullOverview) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Display the movie overview
      Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
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


Widget _showTrailerDialog(String videoKey) {
  return Container(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: videoKey,
            flags: const YoutubePlayerFlags(
              autoPlay: false,
              mute: false,
            ),
          ),
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,
        ),
      ],
    ),
  );
}

Widget _showNoTrailerDialog() {
  return Container(
    child: const Text('Trailer not available.'),
  );
}

Future<Map<String, dynamic>?> _getMovieDetail(dynamic movie) async {
  try {
    final ApiService apiService = ApiService();
    return await apiService.fetchMovieDetails(movie['id']);
  } catch (e) {
    print('Error fetching movie details: $e');
    return null;
  }
}


Widget _buildOverview(String overview, bool showFullOverview) {
  final bool isTruncated = overview.length > 150;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        showFullOverview ? overview : (isTruncated ? overview.substring(0, 150) + '...' : overview),
        textAlign: TextAlign.justify,
      ),
      if (isTruncated && !showFullOverview)
        TextButton(
          onPressed: () {
            // Handle the action to show full overview
            // You can implement this functionality based on your requirement
          },
          child: Text('Show More'),
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
        style: TextStyle(
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
        return CircularProgressIndicator();
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
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(cast.length, (index) {
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
                  overflow: TextOverflow.ellipsis, // Trunca el texto si es demasiado largo
                  maxLines: 2, // Limita el número máximo de líneas
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  ),
),

            ],
          ],
        );
      }
    },
  );
}
