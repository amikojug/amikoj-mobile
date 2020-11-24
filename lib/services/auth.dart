import 'package:amikoj/models/user_module.dart';
import 'package:amikoj/redux/app_state.dart';
import 'package:amikoj/redux/room_reducer.dart';
import 'package:amikoj/redux/user_reducer.dart';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:amikoj/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fbLogin = FacebookLogin();

  UserModule _userFromFireBaseUser(User user) {
    return user != null ? UserModule(uid: user.uid) : null;
  }

  Stream<UserModule> get user {
    return _auth.authStateChanges().map(_userFromFireBaseUser);
  }

  UserModule getCurrentUser() {
    return _userFromFireBaseUser(_auth.currentUser);
  }

  Future<UserModule> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFireBaseUser(user);
    } catch (e) {
      print(e.toString());

      return null;
    }
  }

  Future signInWithEmailAndPassword(email, password) async {
    try {
      final UserCredential result = (await _auth.signInWithCredential(
          EmailAuthProvider.credential(email: email, password: password)));
      User user = result.user;
      return _userFromFireBaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print(e.code.toString());
      }
    } catch (e) {
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      // create a new document fir the user with uid
      await DatabaseService(uid: user.uid).updateUserData('', 0, 0, 0, 0);
      return _userFromFireBaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<UserModule> signInWithFacebook() async {
    try {
      final AccessToken result = await FacebookAuth.instance.login();
      // Create a credential from the access token
      final FacebookAuthCredential facebookAuthCredential =
      FacebookAuthProvider.credential(result.token);

      // Once signed in, return the UserCredential
      UserCredential userCredential = await _auth.signInWithCredential(facebookAuthCredential);
      User user = userCredential.user;
      return _userFromFireBaseUser(user);
    } on FacebookAuthException catch (e) {
      print("FacebookAuthException");
      print(e.toString());
      print(e.message);
      print(e.errorCode);
      return null;
    }
  }

  Future loginWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      return _userFromFireBaseUser(authResult.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut(BuildContext context) async {
    try {
      StoreProvider.of<AppState>(context).dispatch(ResetRoom());
      StoreProvider.of<AppState>(context).dispatch(ResetUser());
      return await _auth.signOut();
    } catch (e) {
      print('error  ' + e.toString());
      return null;
    }
  }
}
