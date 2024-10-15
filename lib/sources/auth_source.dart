import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_session/d_session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sewa_motor/models/account.dart';

class AuthSource {
  static Future<String> signUp(
    String name,
    String email,
    String password,
  ) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Account account = Account(
        uid: credential.user!.uid,
        name: name,
        email: email,
      );
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(account.uid)
          .set(account.toJson());
      return 'success';
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          return 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          return 'The account already exists for that email.';
        }
      }
      log(e.toString());
      return 'something wrong';
    }
  }

  static Future<String> signIn(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final accountDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(credential.user!.uid)
          .get();
      await DSession.setUser(Map<String, dynamic>.from(accountDoc.data()!));
      return 'success';
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          return 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          return 'Wrong password provided for that user.';
        }
      }
      log(e.toString());
      return 'something went wrong';
    }
  }
}
