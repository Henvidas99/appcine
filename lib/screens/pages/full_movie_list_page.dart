import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_movie_data_base/screens/pages/movie_detail_page.dart';
import 'package:google_fonts/google_fonts.dart';

class FullMovieListPage extends StatelessWidget {
  final String title;
  final List<dynamic> movieList;
  final Map<int, String> genres;

  const FullMovieListPage({super.key, required this.title, required this.movieList, required this.genres});

  @override
Widget build(BuildContext context) {
  
  return Scaffold(
    appBar: AppBar(
       title: Text(title,
        style: GoogleFonts.oswald(
          textStyle: const TextStyle( fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white,),
          ),
        ), 
       centerTitle: true,
    ),
    body: GridView.count(
        crossAxisCount: 3, 
        mainAxisSpacing: 2.0, 
        childAspectRatio: 0.7, 
        children: movieList.map<Widget>((item) {
          
            List<String> movieGenres = [];
            List<int> genreIds = List<int>.from(item['genre_ids']);
            for (var genreId in genreIds) {
            String genreName = genres[genreId] ?? 'Otros';
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
                PageTransition(
                  type: PageTransitionType.bottomToTop,
                  reverseDuration: const Duration(milliseconds: 500),
                  duration: const Duration(milliseconds: 500),
                  child: MovieDetailPage(
                    movie:item, showButton: title == 'Estrenos' ? true : false, genreList: movieGenres,
                )
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