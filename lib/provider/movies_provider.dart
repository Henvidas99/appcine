import 'package:flutter/material.dart';
import 'package:the_movie_data_base/services/api.service.dart';

class MoviesProvider with ChangeNotifier {
  List<dynamic> _recentMoviesData = [];
  List<dynamic> _nowPlayingData = [];
  List<dynamic> _upcomingData = [];
  List<dynamic> _trendingData = [];
  List<dynamic> _topRatedData = [];
  List<dynamic> _popularData = [];
  Map<int, String> _genres = {};
  bool _isLoading = true;

  final ApiService apiService = ApiService();

  List<dynamic> get recentMoviesData => _recentMoviesData;
  List<dynamic> get nowPlayingData => _nowPlayingData;
  List<dynamic> get upcomingData => _upcomingData;
  List<dynamic> get trendingData => _trendingData;
  List<dynamic> get topRatedData => _topRatedData;
  List<dynamic> get popularData => _popularData;
  Map<int, String> get genres => _genres;
  bool get isLoading => _isLoading;

  MoviesProvider() {
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      await _fetchRecentData();
      await _fetchGenres();
      await _fetchTrending();
      await _fetchActualMovies();
      await _fetchUpcomingMovies();
      await _fetchTopRatedMovies();
      await _fetchPopularMovies();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      //print('Error: $e');
    }
  }

  Future<void> _fetchRecentData() async {
    try {
      final movieData = await apiService.fetchPopularMovies();
      _recentMoviesData = movieData;
      notifyListeners();
    } catch (e) {
      //print('Error fetching recent data: $e');
    }
  }

  Future<void> _fetchActualMovies() async {
    try {
      final movieData = await apiService.fetchActualMovies();
      _nowPlayingData = movieData;
      notifyListeners();
    } catch (e) {
      //print('Error fetching actual movies: $e');
    }
  }

  Future<void> _fetchUpcomingMovies() async {
    try {
      final movieData = await apiService.fetchUpcomingMovies();
      _upcomingData = movieData;
      notifyListeners();
    } catch (e) {
      //print('Error fetching upcoming movies: $e');
    }
  }

  Future<void> _fetchGenres() async {
    try {
      final Map<int, String> genres = await apiService.fetchGenres();
      _genres = genres;
      notifyListeners();
    } catch (e) {
      //print('Error fetching genres: $e');
    }
  }

  Future<void> _fetchTrending() async {
    try {
      final data = await apiService.fetchTrending();
      _trendingData = data;
      notifyListeners();
    } catch (e) {
      //print('Error fetching trending data: $e');
    }
  }

  Future<void> _fetchTopRatedMovies() async {
    try {
      final data = await apiService.fetchTopRatedMovies();
      _topRatedData = data;
      notifyListeners();
    } catch (e) {
      //print('Error fetching top rated movies: $e');
    }
  }

  Future<void> _fetchPopularMovies() async {
    try {
      final data = await apiService.fetchPopularMovies();
      _popularData = data;
      notifyListeners();
    } catch (e) {
      //print('Error fetching popular movies: $e');
    }
  }
}
