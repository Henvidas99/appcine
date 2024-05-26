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
  late String _videoKey="";
  bool _isControllerInitialized = false;

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
          flags: const YoutubePlayerFlags(
            enableCaption: true,
            autoPlay: false,
            mute: false,
            forceHD: true,
          ),
        );
        _isControllerInitialized = true;
      });
    } else {
      print('Error: Trailer key is null');
      setState(() {

        _controller = YoutubePlayerController(initialVideoId: ''
        );
        _isControllerInitialized = true;
      });
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
  return _isControllerInitialized
  ? _videoKey.isNotEmpty
    ? YoutubePlayer(
        thumbnail: Image.network(
          'https://image.tmdb.org/t/p/w500${widget.movie['poster_path']}',
          fit: BoxFit.cover,
        ),
        controlsTimeOut: const Duration(milliseconds: 1500),
        aspectRatio: 16 / 9,
        controller: _controller,
        showVideoProgressIndicator: true,
        bufferIndicator: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          ),
        ),
        progressIndicatorColor: Colors.amber,
        bottomActions: [
          CurrentPosition(),
          ProgressBar(
            isExpanded: true,
            colors: const ProgressBarColors(
              playedColor: Colors.white,
              handleColor: Colors.amber,
            ),
          ),
          RemainingDuration(),
          FullScreenButton(),
        ],
      )
    : Container(
        height: 200,
        color: Colors.black, // Cambia el color del contenedor según sea necesario
        child: const Center(child: Text("Trailer no disponible", style: TextStyle(fontSize: 16, color: Colors.white),))
      )
  : Container(
      height: 200,
      color: Colors.black, 
      
    );
}


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
