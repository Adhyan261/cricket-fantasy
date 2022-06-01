import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:win_fantasy11/data/data.dart';
import 'package:win_fantasy11/screen/home_screen/home_screen.dart';
import 'package:win_fantasy11/screen/saved_teams/saved_team_preview.dart';
import 'saved_team_view.dart';

class Saved_teams extends StatefulWidget {
  final String match_id;

  Saved_teams({required this.match_id});

  @override
  State<Saved_teams> createState() => _Saved_teamsState();
}

class _Saved_teamsState extends State<Saved_teams> {

  void initState() {
    super.initState();
    get_points();
  }

  Match_data match_points = Match_data();

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CircularProgressIndicator indicator = CircularProgressIndicator(backgroundColor: Colors.grey,color: Colors.blueAccent,strokeWidth: 6,);

  Map<String,dynamic> points ={};

  Future get_points() async
  {
    points = await match_points.get_fantasy_points(widget.match_id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4C52FF),
        title: Text(
          'My Teams',
          style: GoogleFonts.mcLaren(),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
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
        child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('Users').doc(_auth.currentUser?.uid)
                .collection('Fantasy_Team').doc(widget.match_id).collection(
                'Teams')
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: indicator,
                );
              }

              List<Team> teams = [];
              int team_num = 1;
              var output = snapshot.data!.docs;
              for (var out in output) {
                final captain = out.get('Captain');
                final vice_captain = out.get('Vice_Captain');
                final value = out.get('Team');
                final wicketkeepers = out.get('Wicketkeepers');
                final batsmen = out.get('Batsmen');
                final allrounders = out.get('Allrounders');
                final bowlers = out.get('Bowlers');
                double total_points = 0;
                final team = Team(
                  captain: captain,
                  vice_captain: vice_captain,
                  value: value,
                  total_points:total_points,
                  points:points,
                  team_num:team_num,
                  wicketkeepers: wicketkeepers,
                  batsmen:batsmen,
                  allrounders: allrounders,
                  bowlers: bowlers,
                );
                teams.add(team);
                team_num++;
              }
              return ListView(
                padding: EdgeInsets.all(10),
                children: teams,
              );
            }
        ),
      ),
    );
  }
}


class Team extends StatefulWidget {
  final String captain;
  final String vice_captain;
  final List value;//players
  late  double total_points;
  final Map<String,dynamic> points;
  final int team_num;
  final List wicketkeepers;
  final List batsmen;
  final List allrounders;
  final List bowlers;

  Team({required this.captain,required this.vice_captain,required this.value,required this.total_points,required this.points,required this.team_num,required this.wicketkeepers,required this.batsmen,required this.allrounders,required this.bowlers});

  @override
  State<Team> createState() => _TeamState();
}

class _TeamState extends State<Team> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
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
        padding: EdgeInsets.all(10),
        child: InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder:(context)=>team_view(captain: widget.captain,vice_captain: widget.vice_captain,value: widget.value,points: widget.points,total_points: widget.total_points,wicketkeepers:widget.wicketkeepers,batsmen: widget.batsmen,allrounders: widget.allrounders,bowlers: widget.bowlers,)));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Team ${widget.team_num}',
                  style:GoogleFonts.mcLaren(
                    fontSize: 20,
                  )),
              IconButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder:(context)=>Saved_team_preview(value: widget.value, total_points: widget.total_points, points: widget.points, vice_captain: widget.vice_captain, captain: widget.captain,wicketkeepers:widget.wicketkeepers,batsmen: widget.batsmen,allrounders: widget.allrounders,bowlers: widget.bowlers,)));
                },
                icon: Icon(Icons.remove_red_eye),
              ),
            ],
          ),
        ),
      ),
    );
  }
}







