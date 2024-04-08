import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'like_icon.dart';
import 'options_screen.dart';

class ContentScreen extends StatefulWidget {
  final String? src;

  const ContentScreen({Key? key, this.src}) : super(key: key);

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _liked = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.src!);
    await Future.wait([_videoPlayerController.initialize()]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      showControls: false,
      looping: true,
    );
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = _videoPlayerController.value.isPlaying;
        });
      }
    });
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? GestureDetector(
                onTap: () {
                  if (_isPlaying) {
                    _videoPlayerController.pause();
                  } else {
                    _videoPlayerController.play();
                  }
                },
                onDoubleTap: () {
                  setState(() {
                    _liked = !_liked;
                  });
                },
                child: Chewie(
                  controller: _chewieController!,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Loading...')
                ],
              ),
        // if (_isPlaying || !_isPlaying)
        //   Positioned(
        //     top: 16,
        //     right: 16,
        //     child: IconButton(
        //       icon: _isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
        //       onPressed: () {
        //         if (_isPlaying) {
        //           _videoPlayerController.pause();
        //         } else {
        //           _videoPlayerController.play();
        //         }
        //       },
        //     ),
        //   ),
        if (_liked)
          Center(
            child: LikeIcon(),
          ),
        OptionsScreen()
      ],
    );
  }
}