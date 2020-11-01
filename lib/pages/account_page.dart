import 'dart:ui';

import 'package:amikoj/redux/app_state.dart';
import 'package:amikoj/redux/user_reducer.dart';
import 'package:amikoj/redux/user_state.dart';
import 'package:amikoj/services/auth.dart';
import 'package:amikoj/services/storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:amikoj/constants/constants.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redux/redux.dart';
import 'package:amikoj/components/app_bar.dart';

class AccountPage extends StatefulWidget {
  final Store<AppState> store;

  AccountPage(this.store);

  @override
  _AccountPageState createState() => new _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File _image;
  final AuthService _auth = AuthService();

  Future getImage(BuildContext context) async {
    var pickedFile = await new ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 10);
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      cropStyle: CropStyle.circle,
    );
    var user = _auth.getCurrentUser();
    String url = await uploadUserAvatar(croppedImage, user.uid);
    StoreProvider.of<AppState>(context)
        .dispatch(UpdateUser(avatarUrl: url));
    setState(() {
      _image = croppedImage;
    });
  }

  @override
  Widget build(BuildContext buildContext) {
    return new StoreConnector<AppState, UserState>(
        rebuildOnChange: true,
        converter: (store) => store.state.userState,
        builder: (context, state) {
          return new Scaffold(
            appBar: AmikojAppBar(),
            body: new Center(
              child: _image == null
                  ? new Text('No image selected.')
                  : new CircleAvatar(backgroundImage: new FileImage(_image), radius: 200.0,),
            ),
            floatingActionButton: new FloatingActionButton(
              onPressed: () { getImage(context); } ,
              tooltip: 'Pick Image',
              child: new Icon(Icons.add_a_photo),
            ),
          );
        },
    );
  }
}