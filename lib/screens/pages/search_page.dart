import 'package:flutter/material.dart';
import 'package:the_movie_data_base/screens/pages/movie_detail_page.dart';
import 'package:the_movie_data_base/services/api.service.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService apiService = ApiService();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;
  Map<int, String> _genres = {}; // Variable para almacenar los géneros

  @override
  void initState() {
    super.initState();
    _fetchGenres();
  }

  Future<void> _fetchGenres() async {
    try {
      final genres = await apiService.fetchGenres();
      setState(() {
        _genres = genres;
      });
    } catch (e) {
      // Manejar errores
    }
  }

  void _searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }
    setState(() {
      _isSearching = true;
    });
    try {
      final results = await apiService.searchMovies(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Buscar películas...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (query) => _searchMovies(query), // Realiza la búsqueda en tiempo real
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _searchMovies(_searchController.text);
            },
          ),
        ],
      ),
      body: _isSearching
          ? Center(child: CircularProgressIndicator())
          : GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 2.0,
              childAspectRatio: 0.7,
              children: _searchResults.map<Widget>((item) {
                List<String> movieGenres = [];
                List<int> genreIds = List<int>.from(item['genre_ids']);
                for (var genreId in genreIds) {
                  String genreName = _genres[genreId] ?? 'Otros';
                  movieGenres.add(genreName);
                }

                final backdropPath = item['backdrop_path'];
                String imageUrl = backdropPath != null
                    ? 'https://image.tmdb.org/t/p/w500$backdropPath'
                    : 'https://fotografias.antena3.com/clipping/cmsimages01/2019/05/29/9B89AC82-4176-4127-89A2-F38F13E0A84E/98.jpg';
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailPage(
                            movie: item,
                            showButton: false,
                            genreList: movieGenres,
                          ),
                        ),
                      );
                    },
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
                            color: Colors.black.withOpacity(0.6),
                            width: double.infinity,
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              item['title'] ?? item['name'],
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
                  ),
                );
              }).toList(),
            ),
    );
  }
}
