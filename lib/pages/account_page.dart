import 'dart:ui';

import 'package:amikoj/components/pill_button.dart';
import 'package:amikoj/components/pill_input.dart';
import 'package:amikoj/redux/app_state.dart';
import 'package:amikoj/redux/user_reducer.dart';
import 'package:amikoj/redux/user_state.dart';
import 'package:amikoj/services/auth.dart';
import 'package:amikoj/services/realtime_database.dart';
import 'package:amikoj/services/storage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/redux.dart';
import 'package:amikoj/components/app_bar.dart';


class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => new _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File _image;
  final AuthService _auth = AuthService();
  final userNameTextController = TextEditingController();

  String userNameText = "";

  @override
  void initState() {
    super.initState();
    userNameTextController.addListener(() {
      setState(() {
        userNameText = userNameTextController.text;
      });
    });
  }

  Future getImage(BuildContext context) async {
    var pickedFile = await new ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 10);
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      cropStyle: CropStyle.circle,
    );
    var user = _auth.getCurrentUser();
    String url = await uploadUserAvatar(croppedImage, user.uid);
    StoreProvider.of<AppState>(context).dispatch(UpdateUser(avatarUrl: url));
    updateYourselfInTheRoom();
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
          backgroundColor: Color(0xFFBB81F6),
          appBar: AmikojAppBar(context),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: _image == null
                    ? new Text('No image selected.')
                    : new CircleAvatar(
                  backgroundImage: new FileImage(_image),
                  radius: 200.0,
                ),
              ),
              Spacer(flex: 2,),
              PillInput("User Name", userNameTextController),
              Spacer(flex: 1,),
              PillButton("Save", action: () {
                StoreProvider.of<AppState>(context)
                    .dispatch(UpdateUserName(name: userNameText));
                updateYourselfInTheRoom();
                Navigator.pop(context);
              },),
              Spacer(flex: 1,),
            ],
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: () {
              getImage(context);
            },
            tooltip: 'Pick Image',
            child: new Icon(Icons.add_a_photo),
          ),
        );
      },
    );
  }
}
