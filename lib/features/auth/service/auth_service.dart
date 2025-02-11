import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran_app/features/auth/presentation/login_screen.dart';
import 'package:quran_app/features/home/presentation/screens/home_screen.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> saveUserToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    User? user = auth.currentUser;
    if (user != null) {
      await prefs.setString("userToken", user.uid);
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      await saveUserToken();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } on FirebaseAuthException catch (e) {
      showError(e);
    }
  }

  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await saveUserToken();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } on FirebaseAuthException catch (e) {
      showError(e);
    }
  }

  Future<void> signout(BuildContext context) async {
    await auth.signOut();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("userToken");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
    Fluttertoast.showToast(
      msg: "Hisobdan chiqildi",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  void showError(FirebaseAuthException e) {
    Fluttertoast.showToast(
      msg: e.message ?? "Xatolik yuz berdi",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
