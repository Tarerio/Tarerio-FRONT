import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void dispose() {
    _controller?.dispose(); // Release video controller resources.
    super.dispose();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Refresh to show the first frame.
      }).catchError((error) {
        // Handle errors if the video cannot be loaded.
        print('Error loading video: $error');
      });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return _controller!.value.isInitialized
        ? Padding(
          padding: const EdgeInsets.only(top:30),
          child: Column(
                children: [
          SizedBox(
            width: 600, // Set the desired width
            height: 400, // Set the desired height
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (_controller!.value.isPlaying) {
                  _controller!.pause();
                } else {
                  _controller!.play();
                }
              });
            },
            child: Icon(
              _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
                ],
              ),
        )
        : const Center(child: CircularProgressIndicator());
  }
}