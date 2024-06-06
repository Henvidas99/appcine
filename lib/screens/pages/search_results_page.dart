import 'package:flutter/material.dart';
import 'package:the_movie_data_base/services/api.service.dart';
import 'package:the_movie_data_base/screens/pages/movie_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_data_base/provider/movies_provider.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;

  const SearchResultsPage({Key? key, required this.query}) : super(key: key);

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final ApiService apiService = ApiService();
  List<dynamic> _searchResults = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSearchResults(widget.query);
  }

  Future<void> _fetchSearchResults(String query) async {
    try {
      final results = await apiService.searchMovies(query);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados de búsqueda'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? const Center(child: Text('No se encontraron resultados.'))
              : GridView.count(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2, // Responsivo
                  childAspectRatio: 0.7,
                  padding: const EdgeInsets.all(8.0),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  children: _searchResults.map<Widget>((movie) {
                    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
                    final List<String> movieGenres = [];
                    final List<int> genreIds = List<int>.from(movie['genre_ids']);
                    for (var genreId in genreIds) {
                      final genreName = moviesProvider.genres[genreId] ?? 'Otros';
                      movieGenres.add(genreName);
                    }
                    final imageUrl = movie['poster_path'] != null
                        ? 'https://image.tmdb.org/t/p/w500${movie['poster_path']}'
                        : 'https://via.placeholder.com/92x138?text=No+Image';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailPage(
                              movie: movie,
                              showButton: true,
                              genreList: movieGenres,
                            ),
                          ),
                        );
                      },
                      child: Container(
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
                              color: Colors.black.withOpacity(0.6),
                              width: double.infinity,
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                movie['title'] ?? movie['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
    );
  }
}
