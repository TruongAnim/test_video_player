import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoPickerScreen extends StatefulWidget {
  @override
  _VideoPickerScreenState createState() => _VideoPickerScreenState();
}

class _VideoPickerScreenState extends State<VideoPickerScreen> {
  List<String> _selectedVideos = [];

  Future<void> _pickVideos() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickVideo(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _selectedVideos.add(image.path);
        });
      }
    } catch (e) {
      print('Error picking videos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Picker and Grid Example'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: _pickVideos,
            child: Text('Pick Videos'),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns in the grid
              ),
              itemCount: _selectedVideos.length,
              itemBuilder: (BuildContext context, int index) {
                return VideoItem(filePath: _selectedVideos[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VideoItem extends StatefulWidget {
  final String filePath;

  VideoItem({required this.filePath});

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    _controller = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) {
        // Ensure the first frame is shown and set state to rebuild UI
        setState(() {});
      });
    ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            height: 180,
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : CircularProgressIndicator(),
          ),
          // Text('Video Path:\n${widget.filePath}'),
        ],
      ),
    );
  }
}
