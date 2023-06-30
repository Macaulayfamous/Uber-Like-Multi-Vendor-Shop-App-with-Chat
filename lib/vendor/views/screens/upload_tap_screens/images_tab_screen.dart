import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../provider/product_provider.dart';

class ImagesTabScreen extends StatefulWidget {
  @override
  State<ImagesTabScreen> createState() => _ImagesTabScreenState();
}

class _ImagesTabScreenState extends State<ImagesTabScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final ImagePicker picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<File> _image = [];

  List<String> _imageUrlList = [];

  chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      print('no image picked');
    } else {
      setState(() {
        _image.add(File(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            itemCount: _image.length + 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, mainAxisSpacing: 8, childAspectRatio: 3 / 3),
            itemBuilder: ((context, index) {
              return index == 0
                  ? Center(
                      child: IconButton(
                          onPressed: () {
                            chooseImage();
                          },
                          icon: Icon(Icons.add)),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(
                            _image[index - 1],
                          ),
                        ),
                      ),
                    );
            }),
          ),
          SizedBox(
            height: 30,
          ),
          TextButton(
            onPressed: () async {
              EasyLoading.show(status: 'Saving Images');
              for (var img in _image) {
                Reference ref =
                    _storage.ref().child('productImages').child(Uuid().v4());

                await ref.putFile(img).whenComplete(() async {
                  await ref.getDownloadURL().then((value) {
                    setState(() {
                      _imageUrlList.add(value);
                    });
                  });
                });
              }

              setState(() {
                _productProvider.getFormData(imageUrlList: _imageUrlList);
                EasyLoading.dismiss();
              });
            },
            child: Text('upload'),
          ),
        ],
      ),
    );
  }
}
