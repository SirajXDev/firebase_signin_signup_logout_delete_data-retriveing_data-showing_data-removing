import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cli/UI/Auth/signup_.dart';
import 'package:flutter_cli/UI/home_screen.dart';

class SplashServices {
  void isLogin(buildcontext, context) {
    Future.delayed(const Duration(seconds: 2), () {
      FirebaseAuth auth = FirebaseAuth.instance;
      final user = auth.currentUser;
      if (user != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SignUPScreen()));
      }
    });
  }
}
