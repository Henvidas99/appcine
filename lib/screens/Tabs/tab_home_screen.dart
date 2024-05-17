import 'package:flutter/material.dart';
import 'package:the_movie_data_base/screens/pages/full_movie_list_page.dart';
import 'package:the_movie_data_base/screens/pages/movie_detail_page.dart';
import 'package:the_movie_data_base/services/api.service.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TabHomeScreen extends StatefulWidget {
  const TabHomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TabHomeScreenState createState() => _TabHomeScreenState();
}

class _TabHomeScreenState extends State<TabHomeScreen> {
  List<dynamic> _recentMoviesData = [];
  List<dynamic> _nowPlayingData = [];
  List<dynamic> _upcomingData = [];
  List<dynamic> trendingItems = [];
  Map<int, String> _genres = {};

  final ApiService apiService = ApiService();
  bool _isLoading = true; // Para controlar si se están cargando los datos

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      await _fetchRecentData();
      await _fetchGenres();
      await _fetchTrending();
      await _fetchActualMovies();
      await _fetchUpcomingMovies();
      if (mounted) {
        setState(() {
          _isLoading = false; // Cambia el estado a false una vez que se hayan cargado los datos
        });
      }
    } catch (e) {
      // Manejar errores
      if (mounted) {
        setState(() {
          _isLoading = false; // Asegúrate de cambiar el estado incluso en caso de error
        });
      }
      print('Error: $e');
    }
  }

  Future<void> _fetchRecentData() async {
     try {
      final movieData = await apiService.fetchPopularMovies();
    if (mounted) {
      setState(() {
         _recentMoviesData = movieData;
      });
    }
  } catch (e) {
    print('Error fetching recent data: $e');
    // Manejar el error según sea necesario
  }
}

Future<void> _fetchActualMovies() async {
     try {
      final movieData = await apiService.fetchActualMovies();
    if (mounted) {
      setState(() {
         _nowPlayingData = movieData;
      });
    }
  } catch (e) {
    print('Error fetching recent data: $e');
    // Manejar el error según sea necesario
  }
}

Future<void> _fetchUpcomingMovies() async {
     try {
      final movieData = await apiService.fetchUpcomingMovies();
    if (mounted) {
      setState(() {
         _upcomingData = movieData;
      });
    }
  } catch (e) {
    print('Error fetching recent data: $e');
    // Manejar el error según sea necesario
  }
}

  Future<void> _fetchGenres() async {
  try {
    final Map<int, String> genres = await apiService.fetchGenres();
    if (mounted) {
      setState(() {
        _genres = genres;
      });
    }
  } catch (e) {
    print('Error fetching genre items: $e');
    // Manejar el error según sea necesario
  }
}


Future<void> _fetchTrending() async {
  try {
    final data = await apiService.fetchTrending();
    
    if (mounted) {
      setState(() {
        trendingItems = data;
      });
    }
  } catch (e) {
    print('Error fetching trending items: $e');
    // Manejar el error según sea necesario
  }
}

List<Widget> _buildExploreSections() {
  List<Widget> trendingSections = []; 
  List<dynamic> premiereData = _recentMoviesData;
  List<dynamic> upcomingData = _upcomingData;
 
  
  List<String> title = ["Cartelera","Estrenos", "Próximos Estrenos"];
  trendingSections.add(_buildSectionHeader(title[0]));
  trendingSections.add(_buildMoviesCarousel());
  
  trendingSections.add(_buildSectionHeader(title[1]));
  trendingSections.add(_buildItemList(premiereData));
  trendingSections.add(const SizedBox(height: 20));

  trendingSections.add(_buildSectionHeader(title[2]));
  trendingSections.add(_buildItemList(upcomingData));
  trendingSections.add(const SizedBox(height: 20));

    return trendingSections;
}



  List<Widget> _buildMoviesSections() {
    List<Widget> sections = [];

    List<dynamic> moviesData = [..._recentMoviesData];

    Map<String, List<dynamic>> dataByGenre = {};
    for (var item in moviesData) {
      List<int> genreIds = List<int>.from(item['genre_ids']);
      for (var genreId in genreIds) {
        String genreName = _genres[genreId] ?? 'Otros';
        dataByGenre.putIfAbsent(genreName, () => []);
        dataByGenre[genreName]!.add(item);
      }
    }

    dataByGenre.forEach((genre, data) {
      sections.add(_buildSectionHeader(genre));
      sections.add(_buildItemList(data));
      sections.add(const SizedBox(height: 20));
    });

    return sections;
  }


  Widget _buildMoviesCarousel() {
    final List<dynamic> allRecentData = [];


for (int i = 0; i < _recentMoviesData.length; i++) {
    allRecentData.add(_recentMoviesData[i]);

}

final List<dynamic> topContent = allRecentData;

  return Padding(
  padding: EdgeInsets.only(top: 8, bottom: 20),
  child: CarouselSlider(
    options: CarouselOptions(
      height: 180.0,
      autoPlay: true,
      autoPlayInterval: const Duration(seconds: 3),
      enableInfiniteScroll: true,
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      pauseAutoPlayOnTouch: true,
      viewportFraction: 0.8,
      enlargeCenterPage: true,
    ),
    items: topContent.map<Widget>((item) {
      final backdropPath = item['backdrop_path'];
      String imageUrl = backdropPath != null
          ? 'https://image.tmdb.org/t/p/w500$backdropPath'
          : 'https://fotografias.antena3.com/clipping/cmsimages01/2019/05/29/9B89AC82-4176-4127-89A2-F38F13E0A84E/98.jpg';
      return Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {  Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MovieDetailPage(movie:item)),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), // Agrega un borde redondeado a la imagen
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover, // Ajusta la imagen para que cubra el contenedor
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter, // Alinea el contenido en la parte inferior del contenedor
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    item['title'] ?? item['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Color del texto
                      fontSize: 16.0, // Tamaño del texto
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

      
  Widget _buildSectionHeader(String title) {
    return Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0,),
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
      if (title != 'Cartelera') 
        GestureDetector(
          onTap: () {
            if (title == 'Estrenos') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FullMovieListPage(title: title, movieList: _recentMoviesData)), // Suponiendo que "upcomingMovies" es tu lista de próximos estrenos
              );
            } else if (title == 'Próximos Estrenos') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FullMovieListPage(title: title, movieList: _upcomingData)), // Suponiendo que "upcomingMovies" es tu lista de próximos estrenos
              );
            }
          },
          child: Icon(Icons.more_horiz),
        ),
    ],
  ),
);

}

  Widget _buildItemList(List<dynamic> dataList) {
  return Padding(
  padding: const EdgeInsets.only(left: 6.0,),
   child: SizedBox(
    height: 270,
    child: ListView(
      scrollDirection: Axis.horizontal,
    children: dataList.take(5).map<Widget>((item) {
      final backdropPath = item['backdrop_path'];
      String imageUrl = backdropPath != null
          ? 'https://image.tmdb.org/t/p/w500$backdropPath'
          : 'https://fotografias.antena3.com/clipping/cmsimages01/2019/05/29/9B89AC82-4176-4127-89A2-F38F13E0A84E/98.jpg';
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () {  Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MovieDetailPage(movie:item)),
              );
            },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover, // Ajusta la imagen para que cubra todo el contenedor
                  width: 155, // Define el ancho deseado para la imagen
                  height: 200, // Define la altura deseada para la imagen
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                    width: 150, // Ancho máximo permitido para el texto
                    child: Text(
                      item['title'] ?? item['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      softWrap: true, // Permitir que el texto se ajuste a varias líneas si es necesario
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
  const Tab(child: Text("Películas")),
  const Tab(child: Text("Acción")),
  const Tab(child: Text("Animación")),
  const Tab(child: Text("Terror")),
];

@override
Widget build(BuildContext context) {
  return _isLoading
      ? const Center(
          child: CircularProgressIndicator(), // Muestra un indicador de carga mientras se cargan los datos
        )
      : DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: null, // Elimina el AppBar
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                height: 0.5, // Altura delgada
                thickness: 0.5,
                color: Color.fromARGB(255, 77, 80, 60), // Color de la línea gris
              ),
              Container(
                color: const Color.fromARGB(255, 184, 56, 47),// Color del contenedor
                height: 35, // Altura del contenedor
                child: TabBar(
                  unselectedLabelColor: Colors.black,
                  indicatorColor: const  Color.fromARGB(255, 19, 110, 185),
                  isScrollable: true,
                  tabs: tabs,
                  labelPadding: const EdgeInsets.only(right: 45), // Ajusta el margen izquierdo
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    buildContent(context, 0), // Contenido de la pestaña 1
                    buildContent(context, 1), // Contenido de la pestaña 2
                    buildContent(context, 2), // Contenido de la pestaña 3
                    buildContent(context, 3), // Contenido de la pestaña 4
                    buildContent(context, 4), // Contenido de la pestaña 5
                  ],
                ),
              ),
              
            ],
          ),
        ),
      );
}



Widget buildContent(BuildContext context, int tabIndex) {
  // Aquí puedes definir el contenido para cada pestaña
  // Puedes usar un Switch para determinar qué contenido mostrar según el índice de la pestaña
  switch (tabIndex) {
    case 0:
      return SingleChildScrollView(
        padding: EdgeInsets.only(top: 15.0), // Define el margen superior aquí
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildExploreSections(),
        ),
      );
    case 1:
      return SingleChildScrollView(
         padding: EdgeInsets.only(top: 20.0),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildMoviesSections(),// Este es el contenido de la pestaña 1
        ),
      );
    case 2:
       return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildMoviesSections(),// Este es el contenido de la pestaña 1
        ),
      );
    case 3:
      return Container(
        // Contenido de la pestaña 4
      );
    case 4:
      return Container(
        // Contenido de la pestaña 5
      );
    default:
      return Container();
  }
}
}