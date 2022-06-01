import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:win_fantasy11/auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:win_fantasy11/data/set_data.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  late String name;
  late String phone;

  Set_Data set = Set_Data();

  late List user =[];

  @override
  void initState() {
    super.initState();
    get_user();
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.black
    );
  }

  void get_user() async
  {
    user = await set.get_user_data();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Profile',style: GoogleFonts.mcLaren(),),
        centerTitle: true,
        backgroundColor: Color(0xFF4C52FF),
      ),
      body: SingleChildScrollView(
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
              Center(
                child: CircleAvatar(
                  radius: 80.0,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('images/avatar.jpg'),
                ),
              ),
              SizedBox(height:30),
              Card(
                child: ListTile(
                  title: (user.length==0)?Text('Name'):Text(user[0]),
                  leading: Icon(Icons.person,),
                  trailing: TextButton(
                    child: Text('Edit'),
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (context){
                            return Dialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 16,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children:<Widget>[
                                    Center(
                                      child:Text('Edit your name'),
                                    ),
                                    SizedBox(height:5),
                                    Container(
                                      child: TextField(
                                        cursorColor: Color(0xFF4C52FF),
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                          hintText: 'Write your name...',
                                          fillColor: Colors.grey[300],
                                          filled:true,
                                        ),
                                        onChanged: (value){
                                          name = value;
                                        },
                                      ),
                                    ),
                                    SizedBox(height:5),
                                    ElevatedButton(
                                      onPressed: () async{
                                        await _firestore.collection('Users').doc(_auth.currentUser?.uid).set({
                                          'name':name,
                                        },SetOptions(merge: true)).then((value){});
                                        showToast('Name has been changed');
                                        Navigator.pop(context);
                                      },
                                      child: Text('SAVE'),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF4C52FF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height:10),
              Card(
                child: ListTile(
                  title: Text(FirebaseAuth.instance.currentUser?.email ?? 'email'),
                  leading: Icon(Icons.email),
                ),
              ),
              SizedBox(height:10),
              Card(
                child: ListTile(
                  title: (user.length==0)?Text('0000000000'):Text(user[1]),
                  leading: Icon(Icons.phone),
                  trailing: TextButton(
                    child: Text('Edit'),
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (context){
                            return Dialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 16,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children:<Widget>[
                                    Center(
                                      child:Text('Edit your Phone No.'),
                                    ),
                                    SizedBox(height:5),
                                    Container(
                                      child: TextField(
                                        cursorColor: Color(0xFF4C52FF),
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                          hintText: 'Write your phone no. ...',
                                          fillColor: Colors.grey[300],
                                          filled:true,
                                        ),
                                        onChanged: (value){
                                          phone = value;
                                        },
                                      ),
                                    ),
                                    SizedBox(height:5),
                                    ElevatedButton(
                                      onPressed: () async{
                                        await _firestore.collection('Users').doc(_auth.currentUser?.uid).set({
                                          'phone':phone,
                                        },SetOptions(merge: true)).then((value){});
                                        showToast('Phone No. has been changed');
                                        Navigator.pop(context);
                                      },
                                      child: Text('SAVE'),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF4C52FF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
