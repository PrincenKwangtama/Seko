import 'package:car_rental/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

class AuthenticationService extends ChangeNotifier {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  User? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }

    return User(
      uid: user.uid,
      email: user.email,
      emailVerified: user.emailVerified,
    );
  }

  Stream<User?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return _userFromFirebase(credential.user);
  }

  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
    String phoneNumber,
    BuildContext buildContext,
  ) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final auth.User user = _firebaseAuth.currentUser!;

    try {
      await users.doc(user.uid).set({
        'email': email,
        'id': user.uid,
        'name': name,
        'status': 'user',
        'phoneNumber': '+$phoneNumber',
        'profilePicture': 'assets/images/profile.jpg',
      });

      await user.updateDisplayName(name);
      await user.reload();
      await user.sendEmailVerification();

      return _userFromFirebase(credential.user);
    } catch (e) {
      print('Firestore write error: $e');
      // Handle the error accordingly, such as displaying an error message to the user
      return null;
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}