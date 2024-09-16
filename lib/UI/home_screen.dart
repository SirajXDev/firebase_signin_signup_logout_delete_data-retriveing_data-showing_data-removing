import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cli/UI/Auth/login.dart';
import 'package:flutter_cli/UI/Auth/signup_.dart';
import 'package:flutter_cli/UI/updated_value.dart';
import 'package:flutter_cli/custom_widget/custombutton.dart';
import 'package:flutter_cli/utils/toast_popup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isdataadded = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController titlecontroller = TextEditingController();
    TextEditingController descriptioncontroller = TextEditingController();
    FirebaseAuth auth = FirebaseAuth.instance;

    DatabaseReference db = FirebaseDatabase.instance.ref('todo');

    return Scaffold(
      appBar: AppBar(
          title: const Text('home screen'),
          backgroundColor: Colors.teal,
          actions: [
            GestureDetector(
                onTap: () {
                  //to sign out
                  auth.signOut().then((v) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  }).onError((error, v) {
                    //  print(error); just for debuging purpose
                    ToastPopUp()
                        .toast(error.toString(), Colors.green, Colors.white);
                  });
                },
                child: const Icon(Icons.logout)),

            // to delet account
            GestureDetector(
                onTap: () {
                  auth.currentUser!.delete().then((v) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUPScreen()));
                  }).onError((error, v) {
                    //print(error);
                    ToastPopUp()
                        .toast(error.toString(), Colors.green, Colors.white);
                  });
                },
                child: const Icon(Icons.delete)),
          ]),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextField(
              controller: titlecontroller,
              decoration: const InputDecoration(
                  hintText: 'Enter title', border: OutlineInputBorder()),
              style: const TextStyle(fontSize: 20.0, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: TextField(
              maxLines: 4,
              controller: descriptioncontroller,
              decoration: const InputDecoration(
                  hintText: 'Enter description', border: OutlineInputBorder()),
              style: const TextStyle(fontSize: 20.0, color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Center(
            child: CustomButton(
              isloading: isdataadded,
              text: 'add data',
              height: 50.0,
              width: 300.0,
              color: Colors.teal,
              onPressed: () {
                setState(() {
                  isdataadded = true;
                });

                String id = DateTime.now().millisecondsSinceEpoch.toString();
                if (titlecontroller.text.isEmpty) {
                  ToastPopUp()
                      .toast('please enter data', Colors.red, Colors.white);
                  setState(() {
                    isdataadded = false;
                  });
                  return;
                } else {
                  // print('this is current time ${id}');
                  db.child(id).set({
                    'title': titlecontroller.text.trim(),
                    'description': descriptioncontroller.text.trim(),
                    'id': id
                  }).then((v) {
                    titlecontroller.clear();
                    descriptioncontroller.clear;
                    ToastPopUp()
                        .toast('data added', Colors.green, Colors.white);
                    setState(() {
                      isdataadded = false;
                    });
                  }).onError((error, v) {
                    ToastPopUp()
                        .toast(error.toString(), Colors.red, Colors.white);
                    setState(() {
                      isdataadded = false;
                    });
                  });
                }
              },
            ),
          ),
          Expanded(
              child: FirebaseAnimatedList(
                  query: db,
                  itemBuilder: (context, snapshot, _, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateDataScreen(
                                  title: snapshot.child('title').value.toString(),
                                  description: snapshot.child('description'). value.toString(),
                                  id: snapshot.child('id').value.toString(),
                                )));
                      },
                      child: ListTile(
                        title: Text(snapshot.child('title').value.toString()),
                        subtitle: Text(
                            snapshot.child('description').value.toString()),
                        trailing: GestureDetector(
                            onTap: () {
                              print(snapshot.child('id').value.toString());
                              db
                                  .child(snapshot.child('id').value.toString())
                                  .remove()
                                  .then((value) {
                                //  print('data deleted successfully'); just for debuging
                                // print('$value');
                                ToastPopUp().toast(
                                    'data deleted', Colors.red, Colors.white);
                              }).onError((Error, v) {
                                ToastPopUp()
                                    .toast(Error, Colors.green, Colors.white);
                              });
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
