import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cli/UI/Auth/signup_.dart';
import 'package:flutter_cli/UI/home_screen.dart';
import 'package:flutter_cli/custom_widget/custombutton.dart';
import 'package:flutter_cli/utils/toast_popup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailcontroller=TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool isloading = false;

  void login() {
    setState(() {
      isloading = true;
    });
    
    auth
        .signInWithEmailAndPassword(
            email: emailcontroller.text.toString().trim(),
            password: passwordcontroller.text.toString().trim())
        .then((v) {
           Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      setState(() {
        isloading = false;
      });
      ToastPopUp().toast('Sign In successful', Colors.green, Colors.white);
    }).onError((error, v) {
      ToastPopUp().toast(error.toString(), Colors.red, Colors.white);
      setState(() {
        isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
    appBar:AppBar() ,
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
       Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter email';
                      }
                      return null;
                    },
                    controller: emailcontroller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: Colors.black)),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    controller: passwordcontroller,
                    decoration: const InputDecoration(
                        fillColor: Colors.black,
                        border: OutlineInputBorder(),
                        hintText: 'Enter your password',
                        hintStyle: TextStyle(color: Colors.black)),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomButton(
                    height: 50.h,
                    width: 100.w,
                    text: 'Login ',
                    color: Colors.teal,
                    isloading: isloading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                    login();
                      }
                    },
                  ),
                      SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Donot have an account?',
                      style: TextStyle(color: Colors.black),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUPScreen()));
                      },
                      child: const Text('Sign Up',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    )
                  ],
                )
                ],
              )),
        )
    ],),
    );
  }
}