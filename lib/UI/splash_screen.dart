
import 'package:flutter/material.dart';
import 'package:flutter_cli/firebase_services/splash%20_services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    SplashServices().isLogin(BuildContext, context);
    super.initState();
  }
  // void initState() {
  //   Future.delayed(const Duration(seconds: 3), () {
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const SignUPScreen(),
  //         ));
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/images/siraj.png')),
          ],
        ),
      ),
    );
  }
}
