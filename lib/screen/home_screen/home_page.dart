import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:win_fantasy11/data/data.dart';
import 'package:win_fantasy11/screen/login_signup/login_page.dart';
import '../contests/join_contest/match_contest_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import '../contests/my_contests/my_matches.dart';
import 'sidebar/point_system.dart';
import 'feedback.dart';
import 'sidebar/profile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _selectedIndex = 0;

  final _pageOptions = [
    MyHomePage(),
    My_contest(),
    Feedback_form(),
  ];

  void _onItemTapped(int index)
  {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:  AppBar(
        toolbarHeight: 80,
        toolbarOpacity: 0.8,
        shadowColor: Colors.lightBlue,
        title: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text('WIN FANTASY XI 🔥',
            style: GoogleFonts.mcLaren(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Color(0xFF4C52FF),
      ),
      drawer: SideDrawer(email: FirebaseAuth.instance.currentUser?.email ?? 'email'),
      body:_pageOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.mcLaren(),
        unselectedLabelStyle: GoogleFonts.mcLaren(),
        currentIndex: _selectedIndex,
        onTap: (index){
          setState(() {
            _selectedIndex = index;
          });
        },
        items:<BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.trophy),
            label: 'My Matches',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.pen),
            label: 'Feedback',
          ),
        ],
      ),
    );
  }
}
class SideDrawer extends StatefulWidget {

  final String email;
  SideDrawer({required this.email});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        radius: 45.0,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('images/avatar.jpg'),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.email,
                      style: GoogleFonts.mcLaren(
                          color: Colors.white
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xFF4C52FF),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile',
                style: GoogleFonts.mcLaren(),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:(context)=>Profile()));
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Point System',
                style: GoogleFonts.mcLaren(),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:(context)=>Point_system()));
              }
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout',
                style: GoogleFonts.mcLaren(),
              ),
              onTap: () async{
                await FirebaseAuth.instance.signOut();
                Navigator.push(context, MaterialPageRoute(builder:(context)=>Login_screen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}