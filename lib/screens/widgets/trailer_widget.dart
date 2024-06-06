import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:the_movie_data_base/services/api.service.dart';

class TrailerWidget extends StatefulWidget {
  final dynamic movie;

  const TrailerWidget({Key? key, required this.movie}) : super(key: key);

  @override
  _TrailerWidgetState createState() => _TrailerWidgetState();
}

class _TrailerWidgetState extends State<TrailerWidget> {
  late YoutubePlayerController _controller;
  late String _videoKey;
  bool _isVideoLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadTrailerKey();
  }

  Future<void> _loadTrailerKey() async {
    try {
      final String? videoKey = await _getTrailerKey(widget.movie);
      if (videoKey != null) {
        setState(() {
          _videoKey = videoKey;
          _controller = YoutubePlayerController(
            initialVideoId: _videoKey,
            flags: YoutubePlayerFlags(
              enableCaption: true,
              autoPlay: false,
              mute: false,
              forceHD: true,
            ),
          );
        });
      } else {
        // Handle error if trailer key is null
        print('Error: Trailer key is null');
      }
    } catch (e) {
      print('Error fetching trailer key: $e');
      // Handle error
    }
  }

  Future<String?> _getTrailerKey(dynamic movie) async {
    final ApiService apiService = ApiService();
    return await apiService.fetchTrailerKey(movie['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Show the movie poster image
        Image.network(
          'https://image.tmdb.org/t/p/w500${widget.movie['poster_path']}',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        // Show the YouTube player or a loading indicator
        _isVideoLoaded
            ? YoutubePlayer(
                controller: _controller,
                aspectRatio: 16 / 9,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.amber,
                bottomActions: [
                  CurrentPosition(),
                  ProgressBar(
                    isExpanded: true,
                    colors: ProgressBarColors(
                      playedColor: Colors.white,
                      handleColor: Colors.amber,
                    ),
                  ),
                  RemainingDuration(),
                  FullScreenButton(),
                ],
              )
            : Center(child: CircularProgressIndicator()),
        // Show play button if video is loaded
        if (_isVideoLoaded)
          Positioned.fill(
            child: Center(
              child: IconButton(
                icon: Icon(Icons.play_arrow),
                iconSize: 50,
                color: Colors.white,
                onPressed: () {
                  _controller.play();
                },
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
