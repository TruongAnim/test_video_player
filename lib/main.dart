import 'package:flutter/material.dart';

import 'grid_video_files.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: VideoGridScreen(),
      home: VideoPickerScreen(),
    );
  }
}
