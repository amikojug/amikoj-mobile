import 'dart:ui';

import 'package:amikoj/services/storage.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:io';

import 'package:amikoj/constants/constants.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';


class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => new _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File _image;
  String _avatar = "";

  Future getImage() async {
    var pickedFile = await new ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 10);
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      cropStyle: CropStyle.circle,
    );
    await uploadUserAvatar(croppedImage, 'abc');
    setState(() {
      _image = croppedImage;
    });
  }

  @override
  void initState() {
    super.initState();
    downloadUserAvatar('abc').then((value) {
      setState(() {
        print(value);
        _avatar = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFAABBCC),
        actions: [
          FlatButton(
            color: Colors.transparent,
            onPressed: () { Navigator.pushNamed(context, '/account'); },
            child: Row(
              children: [
                Text("Best name", style: whiteText,),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      key: Key(_avatar),
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      imageUrl: _avatar,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: new Center(
        child: _image == null
            ? new Text('No image selected.')
            : new CircleAvatar(backgroundImage: new FileImage(_image), radius: 200.0,),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }
}