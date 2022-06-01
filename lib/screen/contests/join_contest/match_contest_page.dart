import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:win_fantasy11/screen/create_team/create_team.dart';
import '../../saved_teams/saved_teams.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:win_fantasy11/data/set_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'match_contest_screen.dart';

class Match_contest extends StatefulWidget {

  final String team1;
  final String team2;
  final String match_id;
  final String start_time;
  Match_contest({required this.team1,required this.team2,required this.match_id,required this.start_time});

  @override
  State<Match_contest> createState() => _Match_contestState();
}

class _Match_contestState extends State<Match_contest> {

  late String Team_1 = widget.team1;
  late String Team_2 = widget.team2;
  late String Match_id = widget.match_id;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late List<bool> _color = List.filled(100, false,growable: true);

  late String teams_num='0';
  late List teams_ref= [];
  Future get_teams () async
  {
      teams_num =  await set_data.get_joined_teams_num(widget.match_id);
      teams_ref = await set_data.get_joined_teams_ref(widget.match_id);
      setState(() {});
  }

  Set_Data set_data = Set_Data();

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
  void initState() {
    super.initState();
    get_teams();
  }

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
            Text('Match Contests',
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
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF4C52FF),Colors.grey.shade600],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF4C52FF),
                                ),
                                onPressed: (){
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        elevation: 16,
                                        child: Container(
                                          child:  StreamBuilder<QuerySnapshot>(
                                          stream: _firestore.collection('Users').doc(_auth.currentUser?.uid)
                                          .collection('Fantasy_Team').doc(widget.match_id).collection(
                                          'Teams')
                                          .snapshots(),
                                          builder: (BuildContext context, snapshot){
                                            if (!snapshot.hasData) {
                                              return Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }
                                            List<Team> _teams = [];
                                            int _team_num = 1;
                                            var output = snapshot.data!.docs;
                                            for (var out in output) {
                                              final team = Team(team_num: _team_num,color: _color);
                                              _teams.add(team);
                                              _team_num++;
                                            }
                                            return Container(
                                              padding: EdgeInsets.all(5),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Center(
                                                      child: Text('Select Team',
                                                      style : GoogleFonts.mcLaren(
                                                        fontSize: 20
                                                      ),),
                                                    ),
                                                    ListView(
                                                      padding: EdgeInsets.all(10),
                                                      shrinkWrap: true,
                                                      children:
                                                      _teams,
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          primary: Color(0xFF4C52FF),
                                                          ),
                                                      onPressed: () async{
                                                          DocumentReference docRef = _firestore.doc('Users/${_auth.currentUser?.uid}/Fantasy_Team/${widget.match_id}/Teams/${_auth.currentUser?.email} Team${(_color.indexWhere((element) =>
                                                          element == true))+1}');
                                                          await get_teams();

                                                         if(_color.contains(true))
                                                           {
                                                             if(teams_ref.contains(docRef))
                                                               {
                                                                 showToast('Already joined with the selected team');
                                                               }
                                                             else
                                                               {
                                                                 List list = [widget.match_id];
                                                                 setState((){
                                                                   _firestore.collection('Users').doc(_auth.currentUser?.uid).set({
                                                                     'contest joined':FieldValue.arrayUnion(list),
                                                                   },SetOptions(merge: true)).then((value){});
                                                                   _firestore.collection('Contest').doc(widget.match_id)
                                                                       .collection('Teams').doc('${_auth.currentUser?.email} Team${(_color.indexWhere((element) =>
                                                                   element == true))+1}').set({
                                                                     'Team' : docRef,
                                                                   });
                                                                   get_teams();
                                                                 });
                                                                 Navigator.pop(context);
                                                                 showToast('Joined Contest');
                                                               }

                                                             }
                                                         else
                                                           {
                                                             showToast('Select a valid team ');
                                                           }
                                                      },
                                                      child: Text('JOIN CONTEST',
                                                      style: GoogleFonts.mcLaren()),
                                                    ),
                                                  ],
                                                ),
                                            );
                                          }
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Text('Join',
                                style: GoogleFonts.mcLaren(),),
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
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey,
        ),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton.extended(
              heroTag: Text('Create Team'),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Create_team(team1:Team_1,team2:Team_2,match_id:Match_id,
                    start_time:widget.start_time)));
              },
              icon: const Icon(Icons.edit),
              label: const Text('Create Team'),
              backgroundColor: Color(0xFF4C52FF),
            ),
             FloatingActionButton.extended(
               heroTag: Text('Saved Teams'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Saved_teams(match_id: widget.match_id)));
                },
                icon: const Icon(FontAwesomeIcons.save),
                 label: const Text('Saved Teams'),
               backgroundColor: Colors.red,

               ),
          ],
        ),
      ),
    );
  }
}

class Team extends StatefulWidget {
  final int team_num;
  late List<bool> color;

  Team({required this.team_num,required this.color});

  @override
  State<Team> createState() => _TeamState();
}

class _TeamState extends State<Team> {

  late int index =  widget.team_num-1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: (widget.color[index])?Colors.redAccent:Colors.white,
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
        child: GestureDetector(
          onTap: (){
            setState(() {
              if(widget.color.contains(true))
                {
                  if(widget.color[index])
                    {
                      widget.color[index] = !widget.color[index];
                    }
                }
              else
                {
                  widget.color[index] = !widget.color[index];
                }
            });
          },
          child: Text('Team ${widget.team_num}'),
        ),
      ),
    );
  }
}
