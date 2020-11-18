import 'package:amikoj/models/user_module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:amikoj/services/database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future loginWithFacebook() async {
    try {
      final facebookLogin = FacebookLogin();
      final FacebookLoginResult resultFacebook =
          await facebookLogin.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ]);
      if (resultFacebook.status == FacebookLoginStatus.Success) {
        final FacebookAccessToken token = resultFacebook.accessToken;
        final AuthCredential fbCredential =
            FacebookAuthProvider.credential(token.token);
        print(token.token);
        print('------------------fbcredential----------------------------');
        print(fbCredential);
        UserCredential result = await _auth.signInWithCredential(fbCredential);
        return _userFromFireBaseUser(result.user);
      }
    } catch (e) {
      print(e.toString());
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

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
