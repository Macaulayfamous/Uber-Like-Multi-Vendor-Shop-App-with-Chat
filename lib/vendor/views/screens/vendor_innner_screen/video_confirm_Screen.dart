// import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:maclay_multi_store/provider/product_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:uuid/uuid.dart';

// class VideoConfirmScreen extends StatefulWidget {
//   final File videoFile;
//   final String videoPath;

//   const VideoConfirmScreen(
//       {super.key, required this.videoFile, required this.videoPath});

//   @override
//   State<VideoConfirmScreen> createState() => _VideoConfirmScreenState();
// }

// class _VideoConfirmScreenState extends State<VideoConfirmScreen> {
//   late VideoPlayerController controller;
//   final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       controller = VideoPlayerController.file(widget.videoFile);
//     });

//     controller.initialize();
//     controller.play();
//     controller.setVolume(1);
//     controller.setLooping(true);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     controller.dispose();
//   }

//   _compressVideo(String videoPath) async {
//     final compressedVideo = await VideoCompress.compressVideo(videoPath,
//         quality: VideoQuality.MediumQuality);

//     return compressedVideo!.file;
//   }

//   ///Uploading video to storage

//   Future<String> _uploadVideoToStorage(String videoPath) async {
//     Reference ref = _firebaseStorage.ref().child('videos').child(Uuid().v4());

//     UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
//     TaskSnapshot snap = await uploadTask;
//     String downloadUrl = await snap.ref.getDownloadURL();
//     return downloadUrl;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ProductProvider _productProvider =
//         Provider.of<ProductProvider>(context);
//     return Scaffold(
//         body: SingleChildScrollView(
//       child: Stack(
//         children: [
//           SizedBox(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             child: VideoPlayer(controller),
//           ),
//           Positioned(
//             bottom: 25,
//             right: 20,
//             child: FloatingActionButton(
//               backgroundColor: Color.fromRGBO(13, 71, 161, 1),
//               onPressed: () async {
//                 EasyLoading.show();
//                 String videoUrl = await _uploadVideoToStorage(widget.videoPath);
//                 _productProvider.getFormData(videoUrl: videoUrl);

//                 EasyLoading.dismiss();
//                 Get.snackbar('Success',
//                     "Your Video Has been Uploaded, You can now go back",
//                     padding: EdgeInsets.all(
//                       15,
//                     ));
//               },
//               child: Text('Post'),
//             ),
//           )
//         ],
//       ),
//     ));
//   }
// }
