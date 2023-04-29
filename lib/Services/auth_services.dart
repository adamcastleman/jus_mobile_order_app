import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jus_mobile_order_app/Models/user_model.dart';
import 'package:jus_mobile_order_app/Services/user_services.dart';

class AuthServices {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(mapFirebaseUserToUserModel);
  }

  UserModel? mapFirebaseUserToUserModel(auth.User? user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Future registerWithEmailAndPassword(
      {required String email,
      required String password,
      required firstName,
      required lastName,
      required phone}) async {
    try {
      auth.UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      auth.User? user = result.user;

      if (user != null) {
        UserServices(uid: user.uid).createUser(
          uid: user.uid,
          email: email,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
        );
      } else {
        throw 'There was a problem creating your account. Please try again later.';
      }
    } on auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw 'This email is already registered';
        case 'invalid-email':
          throw 'This email is badly formatted or otherwise invalid';
        case 'weak-password':
          throw 'This password is too weak. Please create a more complex password';
        default:
          throw 'There was a problem creating your account. Please try again later.';
      }
    }
  }

  Future loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on auth.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw 'There is no account associated with this email address.';
        case 'wrong-password':
          throw 'The password entered is incorrect.';
        case 'invalid-email':
          throw 'This email is badly formatted or otherwise invalid.';
        case 'too-many-requests':
          throw 'There have been too many failed attempts. Please wait and try later.';
        default:
          'There was a problem logging you in. Please try again later.';
      }
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw 'This email is badly formatted or otherwise invalid.';
        case 'missing-email':
          throw 'Please enter a valid email address';
        case 'user-not-found':
          throw 'There is no account associated with this email address.';
        default:
          'There was a problem logging you in. Please try again later.';
      }
    }
  }

  Future<void> updatePassword(String password) async {
    try {
      await FirebaseFunctions.instance
          .httpsCallable('updatePassword')
          .call({'password': password});
    } on auth.FirebaseAuthException catch (e) {
      throw e.message.toString();
    }
  }

  Future<void> signOut() async {
    try {
      return _auth.signOut();
    } on auth.FirebaseAuthException catch (e) {
      throw e.message.toString();
    }
  }
}
