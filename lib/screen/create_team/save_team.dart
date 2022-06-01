import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:win_fantasy11/screen/home_screen/home_screen.dart';
import 'package:win_fantasy11/screen/contests/join_contest/match_contest_page.dart';
import 'package:win_fantasy11/data/set_data.dart';

class Save_team extends StatefulWidget {
  final List<String> batsmen;
  final List<String> wicketkeeper;
  final List<String> bowlers;
  final List<String> allrounders;
  final String match_id;
  final String team1;
  final String team2;
  final String start_time;

  Save_team({required this.batsmen,required this.bowlers,required this.allrounders,required this.wicketkeeper,required this.match_id,required this.team1,required this.team2,required this.start_time});

  @override
  State<Save_team> createState() => _Save_teamState();
}

class _Save_teamState extends State<Save_team> {

  Set_Data set_data = Set_Data();

  final _firestore = FirebaseFirestore.instance;

  late List<String> b = List.filled(widget.batsmen.length, 'bat');
  late List<String> w = List.filled(widget.wicketkeeper.length, 'wk');
  late List<String> bo = List.filled(widget.bowlers.length, 'ball');
  late List<String> al = List.filled(widget.allrounders.length, 'bat_ball');
  late List<String> image = w+b+al+bo;
  late List<String> players = widget.wicketkeeper+widget.batsmen+widget.allrounders+widget.bowlers;

  late List<bool> _color_vc = List.filled(11,false,growable: false);
  late List<bool> _color_c = List.filled(11,false,growable: false);
  String vc_name = '';
  String c_name = '';
  final int a=1;

  final _auth = FirebaseAuth.instance;
  late String messageText;

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.blueAccent,
        textColor: Colors.black
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4C52FF),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Your Fantasy Team',
          style: GoogleFonts.mcLaren(),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: ListView.builder(
            itemCount: 11,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index)
            {
              return Column(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      title: Text(players[index],
                        style: GoogleFonts.mcLaren(),
                      ),
                      tileColor: Colors.white,
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        backgroundImage: AssetImage(
                            'images/${image[index]}.jpg'),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: (){
                              setState((){
                                if(_color_vc.contains(true))
                                {
                                  if(vc_name==players[index])
                                  {
                                    _color_vc[index] = !_color_vc[index];
                                    vc_name = '';
                                  }
                                }
                                else
                                {
                                  _color_vc[index] = !_color_vc[index];
                                  vc_name = players[index];
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: (_color_vc[index])?Colors.blueAccent:Colors.grey[300],
                              child: Text('VC',
                                style: GoogleFonts.mcLaren(
                                  color: Colors.black,
                                ),),
                            ),
                          ),
                          SizedBox(width:5),
                          GestureDetector(
                            onTap: (){
                              setState((){
                                if(_color_c.contains(true))
                                {
                                  if(c_name==players[index])
                                  {
                                    _color_c[index] = !_color_c[index];
                                    c_name = '';
                                  }
                                }
                                else
                                {
                                  _color_c[index] = !_color_c[index];
                                  c_name = players[index];
                                }
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: (_color_c[index])?Colors.blueAccent:Colors.grey[300],
                              child: Text('C',
                                style: GoogleFonts.mcLaren(
                                  color: Colors.black,
                                ),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: FlatButton(
          color: Colors.red,
          onPressed: ()async{
            if(vc_name==''||c_name=='')
            {
              showToast('Select Captain and Vice-Capatain');
            }
            else if(vc_name==c_name)
            {
              showToast('Captain and Vice-Captain cannot be same');
            }
            else
            {
              String team_num = await set_data.get_team_num(widget.match_id);
              await set_data.set_team_data(team_num,widget.match_id, players, c_name, vc_name, widget.wicketkeeper, widget.batsmen, widget.allrounders, widget.bowlers);
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
          child: Center(child: Text('Save Team',
            style: GoogleFonts.mcLaren(
                fontSize: 20,
                color: Colors.white
            ),
          )),
        ),
      ),
    );
  }
}
