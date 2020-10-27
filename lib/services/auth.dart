import 'package:amikoj/components/user_module.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:amikoj/services/database.dart';
import 'package:flutter/services.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModule _userfromFireBaseUser(User user) {
    return user != null ? UserModule(uid: user.uid) : null;
  }

  Stream<UserModule> get user {
    return _auth.authStateChanges().map(_userfromFireBaseUser);
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userfromFireBaseUser(user);
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
      return _userfromFireBaseUser(user);
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
      return _userfromFireBaseUser(user);
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
