import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_movie_data_base/screens/pages/full_movie_list_page.dart';
import 'package:the_movie_data_base/screens/pages/movie_detail_page.dart';
import 'package:the_movie_data_base/screens/pages/search_page.dart';
import 'package:the_movie_data_base/services/api.service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_data_base/provider/movies_provider.dart';
import 'package:google_fonts/google_fonts.dart';



class TabHomeScreen extends StatefulWidget {
  const TabHomeScreen({super.key});

  @override
  _TabHomeScreenState createState() => _TabHomeScreenState();
}

class _TabHomeScreenState extends State<TabHomeScreen> {
  final ApiService apiService = ApiService();
  bool _isLoading = true;
  DateTime? lastPressed; // Definir lastPressed como una variable de instancia

  @override
  void initState() {
    super.initState();
    _fetchData();
    BackButtonInterceptor.add(interceptor);
  }

  @override
  void dispose() {
    super.dispose();
    BackButtonInterceptor.remove(interceptor);
  }

  bool interceptor(bool btnEvent, RouteInfo info) {
    if (BackButtonInterceptor.getCurrentNavigatorRouteName(context) != '/') return false;
    final now = DateTime.now();
    if (lastPressed == null || now.difference(lastPressed!) > const Duration(seconds: 3)) {
      lastPressed = now;
      final snackBar = SnackBar(
        backgroundColor: Colors.blueGrey,
        margin: const EdgeInsets.only(bottom: 60.0, left: 40, right: 40),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),  
          ),
          child: const Center(
            child: Text(
              'Presiona nuevamente para salir',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return true;
    }
    return false;
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
                    PageTransition(
                      type: PageTransitionType.bottomToTop,
                      reverseDuration: const Duration(milliseconds: 500),
                      duration: const Duration(milliseconds: 500),
                      child: MovieDetailPage(
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
                         style: const TextStyle( fontSize: 16, fontWeight: FontWeight.bold, ),
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
            style: GoogleFonts.oswald(
            textStyle: const TextStyle( fontSize: 20, fontWeight: FontWeight.bold, ),
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
                    PageTransition(
                      type: PageTransitionType.scale,
                      reverseDuration: const Duration(milliseconds: 500),
                      alignment: Alignment.bottomCenter,
                      duration: const Duration(milliseconds: 500),
                      child: FullMovieListPage(
                        title: title,
                        movieList: moviesProvider.recentMoviesData,
                        genres: moviesProvider.genres,
                      ),
                    ),
                  );
                } else if (title == 'Próximos Estrenos') {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.scale,
                      reverseDuration: const Duration(milliseconds: 500),
                      alignment: Alignment.bottomCenter,
                      duration: const Duration(milliseconds: 500),
                      child: FullMovieListPage(
                        title: title,
                        movieList: moviesProvider.upcomingData,
                        genres: moviesProvider.genres,
                      ),
                    ),
                  );
                } else if (title == 'Populares') {
                  Navigator.push(
                    context,
                     PageTransition(
                      type: PageTransitionType.scale,
                      reverseDuration: const Duration(milliseconds: 500),
                      alignment: Alignment.bottomCenter,
                      duration: const Duration(milliseconds: 500),
                      child: FullMovieListPage(
                        title: title,
                        movieList: moviesProvider.popularData,
                        genres: moviesProvider.genres,
                      ),
                    ),
                  );
                } else if (title == 'Mejor Calificadas') {
                  Navigator.push(
                    context,
                     PageTransition(
                      type: PageTransitionType.scale,
                      reverseDuration: const Duration(milliseconds: 500),
                      alignment: Alignment.bottomCenter,
                      duration: const Duration(milliseconds: 500),
                      child: FullMovieListPage(
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

  Widget _buildItemList(MoviesProvider moviesProvider, List<dynamic> dataList, String title) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 44) / 2; // Ajusta el tamaño del elemento según el ancho de la pantalla

    return Padding(
      padding: const EdgeInsets.all(10.0),
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
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: GestureDetector(
                onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.bottomToTop,
                    reverseDuration: const Duration(milliseconds: 300),
                    duration: const Duration(milliseconds: 500),
                    child: MovieDetailPage(
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
                        width: itemWidth,
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
                            width: itemWidth,
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
                title: Image.asset(
                  'assets/palomitaLente.png',
                  height: 35,
                ),
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                toolbarHeight: 35,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    color: Theme.of(context).iconTheme.color,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    height: 0.5, // Altura delgada
                    thickness: 0.5,
                    color: Color.fromARGB(255, 77, 80, 60), 
                  ),
                  Container(
                    color: Theme.of(context).appBarTheme.backgroundColor, 
                    height: 35, // Altura del contenedor
                    child: TabBar(
                      dividerColor: const Color.fromARGB(255, 77, 80, 60),
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Theme.of(context).iconTheme.color,
                      indicatorColor: Theme.of(context).primaryColor,
                      isScrollable: false,
                      tabs: tabs,
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        buildContent(context, 0), 
                        buildContent(context, 1), 
                        buildContent(context, 2), 
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

