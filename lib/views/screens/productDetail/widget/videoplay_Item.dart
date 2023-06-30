// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoPlayerItem extends StatefulWidget {
//   final String videoUrl;

//   const VideoPlayerItem({Key? key, required this.videoUrl}) : super(key: key);
//   @override
//   _VideoPlayerItemState createState() => _VideoPlayerItemState();
// }

// class _VideoPlayerItemState extends State<VideoPlayerItem> {
//   late VideoPlayerController videoPlayerController;

//   @override
//   void initState() {
//     super.initState();
//     videoPlayerController = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((value) {
//         videoPlayerController.play();
//         videoPlayerController.setVolume(10);
//         videoPlayerController.setLooping(true);
//       });
//   }

//   @override
//   void dispose() {
//     videoPlayerController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height,
//       decoration: BoxDecoration(
//         color: Colors.black,
//       ),
//       child: VideoPlayer(videoPlayerController),
//     );
//   }
// }
