import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cli/custom_widget/custombutton.dart';
import 'package:flutter_cli/utils/toast_popup.dart';

class UpdateDataScreen extends StatefulWidget {
  final title;
  final description;
  final id;
  const UpdateDataScreen(
      {super.key,
      required this.title,
      required this.description,
      required this.id});

  @override
  State<UpdateDataScreen> createState() => _UpdateDataScreenState();
}

class _UpdateDataScreenState extends State<UpdateDataScreen> {
   bool isdataadded = false;
  TextEditingController updatetitlecontroller = TextEditingController();
  TextEditingController updatedescriptionecontroller = TextEditingController();

  DatabaseReference db = FirebaseDatabase.instance.ref('todo');

  Widget build(BuildContext context) {
    updatetitlecontroller.text = widget.title.toString();
    updatedescriptionecontroller.text = widget.description.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('update the values'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(fontSize: 20.0, color: Colors.black),
              controller: updatetitlecontroller,
              decoration: const InputDecoration(
                  hintText: 'title', border: OutlineInputBorder()),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: const TextStyle(fontSize: 20.0, color: Colors.black),
              controller: updatedescriptionecontroller,
              decoration: const InputDecoration(
                  hintText: 'desc', border: OutlineInputBorder()),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          CustomButton(
            isloading: isdataadded,
            text: 'update',
            color: Colors.teal,
            height: 50.0,
            width: 100.0,
            onPressed: () {
              setState(() {
                isdataadded=true;
              });
              
              db.child(widget.id).update({
                'title': updatetitlecontroller.text.trim(),
                'description': updatedescriptionecontroller.text.trim()
              }).then((value) {
                setState(() {
                  isdataadded=false;
                });
                ToastPopUp().toast('updated', Colors.green, Colors.white);
                Navigator.pop(context);
              }).onError((error, stackTrace) {
                setState(() {
                  isdataadded=false;
                });
                ToastPopUp().toast(error.toString(), Colors.red, Colors.white);
              });
            },
          )
        ],
      ),
    );
  }
}
