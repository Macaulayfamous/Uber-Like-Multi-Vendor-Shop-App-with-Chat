// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// import '../vendor_innner_screen/video_confirm_Screen.dart';

// class VideoScreen extends StatelessWidget {
//   const VideoScreen({super.key});

//   _pickVideo() async {
//     final video = await ImagePicker().pickVideo(source: ImageSource.gallery);

//     if (video != null) {
//       Get.to(VideoConfirmScreen(
//         videoFile: File(video.path),
//         videoPath: video.path,
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(
//             child: OutlinedButton(
//               onPressed: () {
//                 _pickVideo();
//               },
//               child: Text(
//                 'Add Video',
//                 style: TextStyle(
//                   fontSize: 20,
//                   letterSpacing: 4,
//                 ),
//               ),
//             ),
//           // )
//         ],
//       ),
//     );
//   }
// }
