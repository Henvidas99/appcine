import 'package:flutter/material.dart';
import 'package:the_movie_data_base/services/api.service.dart';

class CreditsWidget extends StatefulWidget {
  final dynamic movie;

  const CreditsWidget({super.key, required this.movie});

  @override
  _CreditsWidgetState createState() => _CreditsWidgetState();
}

class _CreditsWidgetState extends State<CreditsWidget> {
  Future<List<dynamic>> _getMovieCredits() async {
    try {
      final ApiService apiService = ApiService();
      return await apiService.fetchMovieCredits(widget.movie['id']);
    } catch (e) {
      print('Error fetching movie credits: $e');
      return []; // Devuelve una lista vacía en caso de error
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _getMovieCredits(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text('Cargando...'));
        } else if (snapshot.hasError || snapshot.data == null) {
          return const Text('Error loading movie credits');
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
                    'Director: $director',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              if (cast != null) ...[
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Elenco:',
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
                              width: 72,
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
}
