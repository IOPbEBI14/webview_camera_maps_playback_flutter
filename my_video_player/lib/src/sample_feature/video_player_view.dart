import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_video_player/src/sample_feature/video_file.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:intl/intl.dart';

/// Displays detailed information about a SampleItem.
class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({Key? key, required this.file}) : super(key: key);
  final VideoFile file;

  static const routeName = '/sample_item';

  @override
  _VideoPlayerViewState createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late YoutubePlayerController _controller;
  late YoutubeMetaData _videoMetaData;
  double _currentPosition = 0;
  bool _isPlayerReady = false;

  @override
  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat("00");
    return YoutubePlayerBuilder(
        onExitFullScreen: () {
          // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
          SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        },
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: false,
          onReady: () {
            _isPlayerReady = true;
          },
        ),
        builder: (context, player) => Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  widget.file.name,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              body: SizedBox(
                height: MediaQuery.of(context).size.height / 3,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    player,
                    Positioned(
                      bottom: 8,
                      left: -15,
                      right: -10,
                      child: Slider(
                        value: _currentPosition,
                        min: 0,
                        max: _videoMetaData.duration.inSeconds * 1.0,
                        onChanged: (double value) {
                          setState(() {
                            _currentPosition = value;
                            _controller.seekTo(
                                Duration(seconds: _currentPosition.round()));
                          });
                        },
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            '${formatter.format(_controller.value.position.inMinutes)}:${formatter.format(_controller.value.position.inSeconds % 60)}',
                            style: const TextStyle(
                              color: Colors.redAccent,
                            ),
                          ),
                        )),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            '${formatter.format(_videoMetaData.duration.inMinutes)}:${formatter.format(_videoMetaData.duration.inSeconds % 60)}',
                            style: const TextStyle(
                              color: Colors.redAccent,
                            ),
                          ),
                        )),
                    Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: _isPlayerReady
                                    ? () {
                                        setState(() {
                                          _controller.seekTo(Duration(
                                              seconds: _controller.value
                                                          .position.inSeconds >=
                                                      10
                                                  ? _controller.value.position
                                                          .inSeconds -
                                                      10
                                                  : 0));
                                        });
                                      }
                                    : null,
                                icon: Icon(
                                  size: 40,
                                  Icons.replay_10_outlined,
                                  color: Colors.redAccent,
                                )),
                            IconButton(
                                onPressed: _isPlayerReady
                                    ? () {
                                        _controller.value.isPlaying
                                            ? _controller.pause()
                                            : _controller.play();
                                        setState(() {});
                                      }
                                    : null,
                                icon: Icon(
                                  size: 40,
                                  _controller.value.isPlaying
                                      ? Icons.pause_outlined
                                      : Icons.play_arrow_outlined,
                                  color: Colors.redAccent,
                                )),
                            IconButton(
                                onPressed: _isPlayerReady
                                    ? () {
                                        setState(() {
                                          _controller.seekTo(Duration(
                                              seconds: _controller.value
                                                      .position.inSeconds +
                                                  10));
                                        });
                                      }
                                    : null,
                                icon: Icon(
                                  size: 40,
                                  Icons.forward_10_outlined,
                                  color: Colors.redAccent,
                                )),
                          ],
                        )),
                  ],
                ),
              ),
            ));
  }

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.file.url,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: true,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _videoMetaData = const YoutubeMetaData();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _videoMetaData = _controller.metadata;
        _currentPosition = _controller.value.position.inSeconds * 1.0;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
