import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:ui';
import '../contests/join_contest/match_contest_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Feedback_form extends StatefulWidget {
  const Feedback_form({Key? key}) : super(key: key);

  @override
  State<Feedback_form> createState() => _Feedback_formState();
}

class _Feedback_formState extends State<Feedback_form> {

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  late String message;

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.black
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF4C52FF),Colors.grey.shade600],
            ),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Container(
                child: TextField(
                  cursorColor: Color(0xFF4C52FF),
                  maxLines: 15,
                  decoration: InputDecoration(
                    hintText: 'Please write your feedback....',
                    fillColor: Colors.grey[300],
                    filled:true,
                  ),
                  onChanged: (value){
                    message = value;
                  },
                ),
              ),
              SizedBox(height:10),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary:Colors.blueGrey,
                  ),
                  onPressed: () async{
                    await _firestore.collection('Users').doc(_auth.currentUser?.uid).set({
                      'Feedback':message,
                    },SetOptions(merge: true)).then((value){});
                    showToast('Feedback has been submitted');
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
