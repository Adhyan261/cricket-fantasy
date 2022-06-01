import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:win_fantasy11/data/data.dart';
import 'package:win_fantasy11/screen/login_signup/login_page.dart';
import '../join_contest/match_contest_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:win_fantasy11/data/set_data.dart';
import '../join_contest/match_contest_screen.dart';

class My_contest_joined extends StatefulWidget {
  final String match_id;
  final String team1;
  final String team2;

  My_contest_joined({required this.match_id,required this.team1,required this.team2});

  @override
  State<My_contest_joined> createState() => _My_contest_joinedState();
}

class _My_contest_joinedState extends State<My_contest_joined> {

  @override
  void initState() {
    super.initState();
    get_teams();
  }

  late String teams_num='0';
  late List teams_ref= [];
  Future get_teams () async
  {
    teams_num =  await set_data.get_joined_teams_num(widget.match_id);
    teams_ref = await set_data.get_joined_teams_ref(widget.match_id);
    setState(() {});
  }

  Set_Data set_data = Set_Data();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Column(
          children: <Widget>[
            Text('Joined Contests',
              style: GoogleFonts.mcLaren(
                fontSize: 20,
              ),
            ),
            Text(
              widget.team1+' VS '+widget.team2,
              style: GoogleFonts.mcLaren(
                fontSize: 10,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF4C52FF),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF4C52FF),Colors.grey.shade600],
          ),
        ),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder:(context)=>Match_contest_screen(total_teams:teams_num,all_teams_ref:teams_ref,match_id: widget.match_id,team1:widget.team1,team2:widget.team2)));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10), //border corner radius
                  boxShadow:[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), //color of shadow
                      spreadRadius: 5, //spread radius
                      blurRadius: 7, // blur radius
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child:Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text('Winnings',
                                style: GoogleFonts.mcLaren(
                                  color: Colors.grey[600],
                                ),),
                              SizedBox(height: 3,),
                              Text('₹00',
                                style:GoogleFonts.mcLaren(),),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text('Winners',
                                style: GoogleFonts.mcLaren(
                                  color: Colors.grey[600],
                                ),),
                              SizedBox(height: 3,),
                              Text('1',
                                style:GoogleFonts.mcLaren(),),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text('Entry',
                                style: GoogleFonts.mcLaren(
                                  color: Colors.grey[600],
                                ),),
                              SizedBox(height: 3,),
                              Text('Free',
                                style:GoogleFonts.mcLaren(),),
                            ],
                          ),
                        ],
                      ),

                      Container(
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.all(20),
                          child: LinearProgressIndicator(
                            value: (int.parse(teams_num))/1000,
                            backgroundColor: Colors.grey[300],
                            color: Color(0xFF4C52FF),
                          )
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Teams joined : $teams_num/1000',
                            style: GoogleFonts.mcLaren(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
