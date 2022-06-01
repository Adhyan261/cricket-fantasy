import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home_screen/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:win_fantasy11/auth/auth.dart';
import 'registration_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../home_screen/home_page.dart';

class Login_screen extends StatefulWidget {
  const Login_screen({Key? key}) : super(key: key);

  @override
  State<Login_screen> createState() => _Login_screenState();
}

class _Login_screenState extends State<Login_screen> {

  final _auth = FirebaseAuth.instance;
  late String password;
  late String email;
  late String User_email;

  bool isloading = false;

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
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF4C52FF),Colors.grey.shade600],
          ),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(30,60,0,0),
                  child: welcomeText(text: 'Hello There,',color: Colors.white),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30,30,30,0),
                  child : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextField(
                        style:TextStyle(
                          fontSize: 18,
                        ),
                        onChanged: (value) {
                          email =value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 1,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      TextField(
                        obscureText: true,
                        style:TextStyle(
                          fontSize: 18,
                        ),
                        onChanged: (value) {
                          password=value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 1,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                        ),
                      ),

                      Container(
                        alignment: Alignment(1.0, 0.0),
                        padding: EdgeInsets.fromLTRB(0, 0,0, 0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 0.4,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onPressed: (){},
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 15),
                        child: ButtonTheme(
                          height: 50,
                          child: button(color: Color(0xFF5C52FF),widget: (isloading)?Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Loading...', style:TextStyle(color: Colors.white,fontSize:15),),
                              SizedBox(width: 10,),
                              CircularProgressIndicator(color: Colors.white,strokeWidth: 5),
                            ],
                          ):
                          Text(
                            'LOGIN',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                            onpressed: ()async{
                              if(email.isEmpty){
                                showToast("Email is empty");
                              }
                              else {
                                if(password.isEmpty){
                                  showToast("Password is Empty");
                                }
                                else {
                                  setState(() {
                                    isloading = true;
                                  });
                                  Future.delayed(const Duration(seconds: 2), (){
                                    setState(() {
                                      isloading = false;
                                    });
                                  });
                                  String message = await context.read<AuthService>().login(
                                    email,
                                    password,
                                  );
                                  if(message=='logged in')
                                    {
                                      Navigator.push(context,MaterialPageRoute(builder: (context)=>Home()));
                                    }
                                  else
                                    {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title:
                                          Text(' Oops! Login Failed'),
                                          content: Text(message,style:GoogleFonts.mcLaren()),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                              },
                                              child: Text('Okay'),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                }
                              }
                            },
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top:10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'New User? ',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Registration_screen()));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class button extends StatelessWidget {

  late Widget widget;
  late VoidCallback onpressed;
  late Color color;

  button({ required this.color,required this.widget,required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: widget,
      onPressed : onpressed,
    );
  }
}

class welcomeText extends StatelessWidget {

  late String text;
  late Color color;
  welcomeText({required this.text,required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 60,
        fontFamily: 'Merriweather',
        fontWeight: FontWeight.bold,
        color: color,
        letterSpacing: 2,
      ),
    );
  }
}

