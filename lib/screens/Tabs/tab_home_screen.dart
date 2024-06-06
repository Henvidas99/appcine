import 'package:flutter/material.dart';
import 'package:the_movie_data_base/screens/pages/full_movie_list_page.dart';
import 'package:the_movie_data_base/screens/pages/movie_detail_page.dart';
import 'package:the_movie_data_base/screens/pages/search_results_page.dart';
import 'package:the_movie_data_base/services/api.service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_data_base/provider/movies_provider.dart';
import 'package:the_movie_data_base/styles/app_colors.dart';

class TabHomeScreen extends StatefulWidget {
  const TabHomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TabHomeScreenState createState() => _TabHomeScreenState();
}

class _TabHomeScreenState extends State<TabHomeScreen> {
  final ApiService apiService = ApiService();
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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

  void _navigateToSearchResults(BuildContext context) {
    final query = _searchController.text;
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsPage(query: query),
        ),
      );
    }
  }

  List<Widget> _buildExploreSections(MoviesProvider moviesProvider) {
    List<Widget> trendingSections = [];
    List<dynamic> premiereData = moviesProvider.recentMoviesData;
    List<dynamic> upcomingData = moviesProvider.upcomingData;

    List<String> title = ["Cartelera", "Estrenos", "Próximos Estrenos"];
    trendingSections.add(_buildSectionHeader(moviesProvider, title[0]));
    trendingSections.add(_buildMoviesCarousel(moviesProvider));

    trendingSections.add(_buildSectionHeader(moviesProvider, title[1]));
    trendingSections.add(_buildItemList(moviesProvider, premiereData, title[1]));
    trendingSections.add(const SizedBox(height: 20));

    trendingSections.add(_buildSectionHeader(moviesProvider, title[2]));
    trendingSections.add(_buildItemList(moviesProvider, upcomingData, ""));
    trendingSections.add(const SizedBox(height: 20));

    return trendingSections;
  }

  List<Widget> _buildCategorySections(MoviesProvider moviesProvider) {
    List<Widget> categorySections = [];

    List<dynamic> popularData = moviesProvider.popularData;
    List<dynamic> topRatedData = moviesProvider.topRatedData;

    List<String> title = ["Populares", "Mejor Calificadas"];

    categorySections.add(_buildSectionHeader(moviesProvider, title[0]));
    categorySections.add(_buildItemList(moviesProvider, popularData, ""));
    categorySections.add(const SizedBox(height: 20));

    categorySections.add(_buildSectionHeader(moviesProvider, title[1]));
    categorySections.add(_buildItemList(moviesProvider, topRatedData, ""));
    categorySections.add(const SizedBox(height: 20));

    return categorySections;
  }

  List<Widget> _buildGenreSections(MoviesProvider moviesProvider) {
    List<Widget> sections = [];

    List<dynamic> moviesData = [...moviesProvider.recentMoviesData];

    Map<String, List<dynamic>> dataByGenre = {};
    for (var item in moviesData) {
      List<int> genreIds = List<int>.from(item['genre_ids']);
      for (var genreId in genreIds) {
        String genreName = moviesProvider.genres[genreId] ?? 'Otros';
        dataByGenre.putIfAbsent(genreName, () => []);
        dataByGenre[genreName]!.add(item);
      }
    }

    dataByGenre.forEach((genre, data) {
      sections.add(_buildSectionHeader(moviesProvider, genre));
      sections.add(_buildItemList(moviesProvider, data, ""));
      sections.add(const SizedBox(height: 20));
    });

    return sections;
  }

  Widget _buildMoviesCarousel(MoviesProvider moviesProvider) {
    final List<dynamic> allRecentData = [];

    for (int i = 0; i < moviesProvider.recentMoviesData.length; i++) {
      allRecentData.add(moviesProvider.recentMoviesData[i]);
    }

    final List<dynamic> topContent = allRecentData;

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 180.0,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          pauseAutoPlayOnTouch: true,
          viewportFraction: 0.8,
          enlargeCenterPage: true,
        ),
        items: topContent.map<Widget>((item) {
          List<String> movieGenres = [];
          List<int> genreIds = List<int>.from(item['genre_ids']);
          for (var genreId in genreIds) {
            String genreName = moviesProvider.genres[genreId] ?? 'Otros';
            movieGenres.add(genreName);
          }

          final backdropPath = item['backdrop_path'];
          String imageUrl = backdropPath != null
              ? 'https://image.tmdb.org/t/p/w500$backdropPath'
              : 'https://fotografias.antena3.com/clipping/cmsimages01/2019/05/29/9B89AC82-4176-4127-89A2-F38F13E0A84E/98.jpg';
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(
                        movie: item,
                        showButton: true,
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
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        item['title'] ?? item['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(MoviesProvider moviesProvider, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (title == 'Estrenos' ||
              title == 'Próximos Estrenos' ||
              title == 'Populares' ||
              title == 'Mejor Calificadas')
            GestureDetector(
              onTap: () {
                if (title == 'Estrenos') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullMovieListPage(
                        title: title,
                        movieList: moviesProvider.recentMoviesData,
                        genres: moviesProvider.genres,
                      ),
                    ),
                  );
                } else if (title == 'Próximos Estrenos') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullMovieListPage(
                        title: title,
                        movieList: moviesProvider.upcomingData,
                        genres: moviesProvider.genres,
                      ),
                    ),
                  );
                } else if (title == 'Populares') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullMovieListPage(
                        title: title,
                        movieList: moviesProvider.popularData,
                        genres: moviesProvider.genres,
                      ),
                    ),
                  );
                } else if (title == 'Mejor Calificadas') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullMovieListPage(
                        title: title,
                        movieList: moviesProvider.topRatedData,
                        genres: moviesProvider.genres,
                      ),
                    ),
                  );
                }
              },
              child: const Icon(Icons.more_horiz),
            ),
        ],
      ),
    );
  }

  Widget _buildItemList(
      MoviesProvider moviesProvider, List<dynamic> dataList, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: SizedBox(
        height: 270,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: dataList.take(5).map<Widget>((item) {
            List<String> movieGenres = [];
            List<int> genreIds = List<int>.from(item['genre_ids']);
            for (var genreId in genreIds) {
              String genreName = moviesProvider.genres[genreId] ?? 'Otros';
              movieGenres.add(genreName);
            }

            final backdropPath = item['backdrop_path'];
            String imageUrl = backdropPath != null
                ? 'https://image.tmdb.org/t/p/w500$backdropPath'
                : 'https://fotografias.antena3.com/clipping/cmsimages01/2019/05/29/9B89AC82-4176-4127-89A2-F38F13E0A84E/98.jpg';
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(
                        movie: item,
                        genreList: movieGenres,
                        showButton: title == 'Estrenos' ? true : false,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: 155,
                        height: 200,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 150,
                            child: Text(
                              item['title'] ?? item['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  List<Tab> tabs = [
    const Tab(child: Text("Explora")),
    const Tab(child: Text("Categorías")),
    const Tab(child: Text("Géneros")),
  ];

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    Image.asset(
                      'assets/palomitaLente.png',
                      height: 35,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: AppColors.blackBackground,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: const InputDecoration(
                                    hintText: 'Buscar películas...',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Colors.grey),
                                  ),
                                  style: const TextStyle(color: AppColors.lightBackground),
                                  onChanged: (query) {
                                    _searchMovies(query);
                                    if (query.isEmpty) {
                                      setState(() {
                                        _searchResults = [];
                                      });
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.search),
                                color: AppColors.lightBackground,
                                onPressed: () {
                                  _navigateToSearchResults(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppColors.blackBackground,
                toolbarHeight: 60,
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    height: 0.5,
                    thickness: 0.5,
                    color: Color.fromARGB(255, 77, 80, 60),
                  ),
                  Container(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    height: 35,
                    child: TabBar(
                      dividerColor: const Color.fromARGB(255, 77, 80, 60),
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Theme.of(context).iconTheme.color,
                      indicatorColor: Theme.of(context).primaryColor,
                      isScrollable: true,
                      tabs: tabs,
                      labelPadding: const EdgeInsets.only(right: 45),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        TabBarView(
                          children: [
                            buildContent(context, 0),
                            buildContent(context, 1),
                            buildContent(context, 2),
                          ],
                        ),
                        if (_searchController.text.isNotEmpty &&
                            _searchResults.isNotEmpty)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: const Color.fromARGB(144, 0, 0, 0),
                              height: 200,
                              child: Material(
                                color: Colors.transparent,
                                elevation: 5,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _searchResults.length,
                                  itemBuilder: (context, index) {
                                    final movie = _searchResults[index];
                                    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
                                    final List<String> movieGenres = [];
                                    final List<int> genreIds = List<int>.from(movie['genre_ids']);
                                    for (var genreId in genreIds) {
                                      final genreName = moviesProvider.genres[genreId] ?? 'Otros';
                                      movieGenres.add(genreName);
                                    }
                                    return ListTile(
                                      leading: Image.network(
                                        movie['poster_path'] != null
                                            ? 'https://image.tmdb.org/t/p/w92${movie['poster_path']}'
                                            : 'https://via.placeholder.com/92x138?text=No+Image',
                                        fit: BoxFit.cover,
                                      ),
                                      title: Text(movie['title'], style: const TextStyle(color: Colors.white)),
                                      subtitle: Text(movie['release_date'], style: const TextStyle(color: Colors.white)),
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
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget buildContent(BuildContext context, int tabIndex) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    switch (tabIndex) {
      case 0:
        return SingleChildScrollView(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildExploreSections(moviesProvider),
          ),
        );
      case 1:
        return SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildCategorySections(moviesProvider),
          ),
        );
      case 2:
        return SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildGenreSections(moviesProvider),
          ),
        );
      default:
        return Container();
    }
  }
}
