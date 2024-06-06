import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String apiKey = 'ded71725655780ba4d50e97a4eccdeec';
  static const String baseUrl = 'https://api.themoviedb.org/3';

   Future<List<dynamic>> searchMovies(String query) async {
    final url = '$baseUrl/search/movie?api_key=$apiKey&query=$query';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['results'];
      return data;
    } else {
      throw Exception('Failed to search movies');
    }
  }

  Future<List<dynamic>> fetchActualMovies() async {
    const url = '$baseUrl/movie/now_playing?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['results'];
      return data;
    } else {
      throw Exception('Failed to load actual movies');
    }
  }

  Future<List<dynamic>> fetchUpcomingMovies() async {
    const url = '$baseUrl/movie/upcoming?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['results'];
      return data;
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }



  Future<List<dynamic>> fetchPopularMovies() async {
    const url = '$baseUrl/movie/popular?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['results'];
      return data;
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<dynamic>> fetchTopRatedMovies() async {
    const url = '$baseUrl/movie/top_rated?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['results'];
      return data;
    } else {
      throw Exception('Failed to load top rated movies');
    }
  }


  Future<List<dynamic>> fetchTrending() async {
    const timeWindow = 'week';
    const url = '$baseUrl/trending/movie/$timeWindow?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['results'];
      return data;
    } else {
      throw Exception('Failed to load trending items');
    }
  }

  Future<Map<int, String>> fetchGenres() async {
    const url = '$baseUrl/genre/movie/list?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['genres'];
      final Map<int, String> genres = {};
      for (var genre in data) {
        genres[genre['id']] = genre['name'];
      }
      return genres;
    } else {
      throw Exception('Failed to load genres');
    }
  }

  Future<List<dynamic>> fetchMovieVideos(int movieId) async {
    final url = '$baseUrl/movie/$movieId/videos?api_key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['results']; 
      return data;
    } else {
      throw Exception('Failed to load movie videos');
    }
  }


Future<String?> fetchTrailerKey(int movieId) async {
  try {
    final trailerUrl =
        'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey';

    final response = await http.get(Uri.parse(trailerUrl));
    if (response.statusCode == 200) {
      final videoData = json.decode(response.body)['results'];
      if (videoData.isNotEmpty) {
        final videoKey = videoData[0]['key'];
        return videoKey;
      } else {
        return null;
      }
    } else {
      return null;
    }
  } catch (e) {
    //print('Error fetching movie trailer: $e');
    return null;
  }
}

Future<Map<String, dynamic>?> fetchMovieDetails(int movieId) async {
  final String url = '$baseUrl/movie/$movieId?api_key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return data;
  } else {
    throw Exception('Failed to load movie details');
  }
}

Future<List<dynamic>> fetchMovieCredits(int movieId) async {

  final String url = '$baseUrl/movie/$movieId/credits?api_key=$apiKey';

  final http.Response response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> cast = data['cast'];
    final dynamic director = _findDirector(data['crew']);
    return [cast, director];
  } else {
    throw Exception('Failed to load movie credits');
  }
}

dynamic _findDirector(List<dynamic> crew) {
  for (final person in crew) {
    if (person['job'] == 'Director') {
      return person['name'];
    }
  }
  return null;
}
}