import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home_screen/home_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:win_fantasy11/auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../home_screen/home_page.dart';



class Registration_screen extends StatefulWidget {
  const Registration_screen({Key? key}) : super(key: key);

  @override
  State<Registration_screen> createState() => _Registration_screenState();
}

class _Registration_screenState extends State<Registration_screen> {
  late String password;
  late String email;
  late String name;
  late String phone;
  final _auth =  FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool isloading = false;

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF4C52FF),Colors.grey.shade600],
            ),
          ),
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
                  child: welcomeText(text: 'Let\'s Get Started',color: Colors.white,size: 40),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[

                    Container(
                      padding: EdgeInsets.fromLTRB(30,30,30,10),
                      child: TextField(
                        obscureText: false,
                        style:TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),

                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Full Name',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 1,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1.0),
                          ),
                        ),
                        onChanged: (value)
                        {
                          name = value;
                        },
                      ),
                    ),


                    Container(
                      padding: EdgeInsets.fromLTRB(30,10,30,10),
                      child: TextField(
                        obscureText: false,
                        style:TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),

                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 1,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1.0),
                          ),
                        ),
                        onChanged: (value)
                        {
                          email = value;
                        },
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.fromLTRB(30,10,30,10),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        style:TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),

                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          hintText: 'Phone No.',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 1,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1.0),
                          ),
                        ),
                        onChanged: (value)
                        {
                          phone = value;
                        },
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.fromLTRB(30,10,30,30),
                      child: TextField(
                        obscureText: true,
                        style:TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),

                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.key),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 1,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1.0),
                          ),
                        ),
                        onChanged: (value)
                        {
                          password = value;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 20, 30, 30),
                      child: ButtonTheme(
                        height: 50,
                        child: button(color: Color(0xFF5C52FF),widget:(isloading)? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('Loading...', style:TextStyle(color: Colors.white,fontSize:15),),
                            SizedBox(width: 10,),
                            CircularProgressIndicator(color: Colors.white,),
                          ],
                        ): Text(
                          'Register',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                          onpressed: () async{
                            if(email.isEmpty||name.isEmpty||phone.isEmpty||password.isEmpty){
                              showToast("All fields are mandatory");
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
                                String message = await context.read<AuthService>().register(
                                  email,
                                  password,
                                  name,
                                  phone,
                                );
                                if(message=='signed up')
                                {
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>Home()));
                                }
                                else
                                {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title:
                                      Text(' Oops! Registeration Failed'),
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
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top:10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Already Registered?',
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
                          'LOG IN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Login_screen()));
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


class welcomeText extends StatelessWidget {

  late String text;
  late Color color;
  late double size;
  welcomeText({required this.text,required this.color,required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontFamily: 'Merriweather',
        fontWeight: FontWeight.bold,
        color: color,
        letterSpacing: 2,
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