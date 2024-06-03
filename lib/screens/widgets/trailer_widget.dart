import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:the_movie_data_base/services/api.service.dart';
import 'package:flutter/services.dart';

class TrailerWidget extends StatefulWidget {
  final dynamic movie;

  const TrailerWidget({super.key, required this.movie});

  @override
  // ignore: library_private_types_in_public_api
  _TrailerWidgetState createState() => _TrailerWidgetState();
}

class _TrailerWidgetState extends State<TrailerWidget> with SingleTickerProviderStateMixin {
  YoutubePlayerController? _controller;
  String _videoKey = "";
  bool _isControllerInitialized = false;
  bool _isVideoEnded = false;

  @override
  void initState() {
    super.initState();
    _loadTrailerKey();
  }

  Future<void> _loadTrailerKey() async {
    try {
      final String? videoKey = await _getTrailerKey(widget.movie);
      if (videoKey != null) {
        if (mounted) {
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
            )..addListener(_videoListener);
            _isControllerInitialized = true;
          });
        }
      } else {
       // print('Error: Trailer key is null');
        if (mounted) {
          setState(() {
            _isControllerInitialized = true;
          });
        }
      }
    } catch (e) {
      //print('Error fetching trailer key: $e');
      // Handle error
      if (mounted) {
        setState(() {
          _isControllerInitialized = true;
        });
      }
    }
  }

  void _videoListener() {
    if (_controller != null && _controller!.value.playerState == PlayerState.ended) {
      if (mounted) {
        setState(() {
          _isVideoEnded = true;
        });
      }
    } else if (_controller != null && _controller!.value.playerState == PlayerState.playing) {
      if (mounted) {
        setState(() {
          _isVideoEnded = false;
        });
      }
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
                controller: _controller!,
                showVideoProgressIndicator: true,
                bufferIndicator: Container(
                  color: Colors.black,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                progressIndicatorColor: Theme.of(context).primaryColor,
                bottomActions: [
                  CurrentPosition(),
                  ProgressBar(
                    isExpanded: true,
                    colors: ProgressBarColors(
                      playedColor: Colors.white,
                      handleColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  RemainingDuration(),
                  if (_isVideoEnded)
                    IconButton(
                      icon: const Icon(Icons.replay),
                      onPressed: () {
                        _controller!.seekTo(Duration.zero);
                        _controller!.play();
                      },
                    )
                  else
                    FullScreenButton(),
                ],
              )
            : Container(
                height: 200,
                color: Colors.black,
                child: const Center(
                  child: Text(
                    "Trailer no disponible",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )
        : Container(
            height: 200,
            color: Colors.black,
          );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _controller?.dispose();
    super.dispose();
  }
}
