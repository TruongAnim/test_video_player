import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VideoGridScreen(),
    );
  }
}

class VideoGridScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Grid'),
      ),
      body: VideoGrid(),
    );
  }
}

class VideoGrid extends StatefulWidget {
  @override
  _VideoGridState createState() => _VideoGridState();
}

class _VideoGridState extends State<VideoGrid> {
  final List<String> videoUrls = [
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4', // Replace with actual video URLs
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4',
    // Add more video URLs as needed
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns in the grid
      ),
      itemCount: 10, //videoUrls.length,
      itemBuilder: (context, index) {
        return VideoCard(videoUrl: videoUrls[index]);
      },
    );
  }
}

class VideoCard extends StatefulWidget {
  final String videoUrl;

  VideoCard({required this.videoUrl});

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        // Ensure the first frame is shown and set state to rebuild UI
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : CircularProgressIndicator(), // Show a loading indicator until the video is initialized
          IconButton(
            icon: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
            onPressed: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
