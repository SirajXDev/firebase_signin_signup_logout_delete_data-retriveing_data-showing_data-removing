import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cli/UI/Auth/login.dart';
import 'package:flutter_cli/UI/home_screen.dart';
import 'package:flutter_cli/custom_widget/custombutton.dart';
import 'package:flutter_cli/utils/toast_popup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUPScreen extends StatefulWidget {
  const SignUPScreen({super.key});

  @override
  State<SignUPScreen> createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<SignUPScreen> {
  //for form validation use this key
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool isloading = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  
//sign up function
  void signup() {
    setState(() {
      isloading = true;
    });
    auth
        .createUserWithEmailAndPassword(
            email: emailcontroller.text.toString().trim(),
            password: passwordcontroller.text.toString().trim())
        .then((v) {
           Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      ToastPopUp().toast('Sign Up successful', Colors.green, Colors.white);
      setState(() {
        isloading = false;
      });
      emailcontroller.clear();
      passwordcontroller.clear();
    }).onError((error, v) {
      ToastPopUp().toast(error.toString(), Colors.red, Colors.white);

      setState(() {
        isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('sign up'),
          centerTitle: true,
        ),
        body: Padding(
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
                    text: 'Sign up',
                    color: Colors.teal,
                    isloading: isloading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signup();
                      }
                    },
                  ),
                      SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.black),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text('Sign In',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    )
                  ],
                )
                ],
              )),
        ));
  }
}
