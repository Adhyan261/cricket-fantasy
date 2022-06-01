import 'dart:io';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:win_fantasy11/data/data.dart';


class Match_contest_screen extends StatefulWidget {
  final String total_teams;
  final List all_teams_ref;
  final String match_id;
  final String team1;
  final String team2;

  Match_contest_screen({required this.total_teams,required this.all_teams_ref,required this.match_id,required this.team1,required this.team2});

  @override
  State<Match_contest_screen> createState() => _Match_contest_screenState();
}

class _Match_contest_screenState extends State<Match_contest_screen> with TickerProviderStateMixin {

  late TabController tabController;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late List all_teams_data = [];
  Match_data match_points = Match_data();
  Map<String,dynamic> points ={};
  CircularProgressIndicator indicator = CircularProgressIndicator(backgroundColor: Colors.grey,color: Colors.blueAccent,strokeWidth: 6,);

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
    get_all_teams_data();
  }

  Future get_points() async
  {
    points = await match_points.get_fantasy_points(widget.match_id);
  }

  List<Map<String,dynamic>> all_teams_points = [];
  List<Map<String,dynamic>> my_teams = [];

  void get_points_total()
   {
     String? email = _auth.currentUser?.email.toString();
    for(var out in all_teams_data)
    {
      List players = out['Players'];
      String captain = out['Captain'];
      String vice = out['Vice-Captain'];
      String team_name = out['Team_Name'];
      late double total_points=0;
      if(points!= {})
        {
          for(var value in players)
          {
            if(value==captain)
            {
              total_points = total_points + (((points[value])!=null)?(2*(points[value])):0);
            }
            else if(value==vice)
            {
              total_points = total_points + (((points[value])!=null)?(1.5*(points[value])):0);
            }
            else
            {
              total_points = total_points + (((points[value])!=null)?(points[value]):0);
            }
          }
          Map<String,dynamic> val = {'Team_Name':team_name,'Points':total_points};
          all_teams_points.add(val);
          if(team_name.contains(email!))
            {
              my_teams.add(val);
            }
        }
      else
        {
          Map<String,dynamic> val = {'Team_Name':team_name,'Points':total_points};
          all_teams_points.add(val);
        }
    }
    all_teams_points.sort((a,b)=>b['Points'].compareTo(a['Points']));
  }

  Future get_all_teams_data() async{
    for(var ref in widget.all_teams_ref)
    {
      await ref.get().then((DocumentSnapshot documentSnapshot)
      {
        if(!documentSnapshot.exists)
        {
          return CircularProgressIndicator();
        }
        final captain = documentSnapshot['Captain'];
        final vice_captain = documentSnapshot['Vice_Captain'];
        final players = documentSnapshot['Team'];
        final wicketkeepers = documentSnapshot['Wicketkeepers'];
        final batsmen = documentSnapshot['Batsmen'];
        final allrounders = documentSnapshot['Allrounders'];
        final bowlers = documentSnapshot['Bowlers'];
        final team_name = documentSnapshot['Team_Name'];
        double total_points = 0;
        Map<String,dynamic> team_data = {'Captain':captain,'Vice-Captain':vice_captain,'Players':players,'Wicketkeepers':wicketkeepers,
          'Batsmen':batsmen,'Allrounders':allrounders,'Bowlers':bowlers,'Team_Name':team_name};
        all_teams_data.add(team_data);
      });
    }
    await get_points();
    get_points_total();
    setState(() {});
  }

  late int rank = 1;

  int diff_rank()
  {
    rank=rank+1;
    return rank;
  }

  int same_rank(int index)
  {
    if(index==0)
      {
        rank=1;
      }
    return rank;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.team1} Vs ${widget.team2}',style:GoogleFonts.mcLaren()),
        centerTitle: true,
        backgroundColor: Color(0xFF4C52FF),
        bottom: TabBar(
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          labelStyle: GoogleFonts.mcLaren(),
          tabs: [
            Tab(text: 'Leaderboard'),
            Tab(text: 'My Teams'),
          ],
          controller: tabController,
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children:<Widget>[
          (all_teams_points.length==0)?Center(child: indicator):ListView.builder(
            itemCount: all_teams_points.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context,index)
            {
              if(index==0)
              {
                return Column(
                  children: <Widget>[
                    ListTile(
                      leading: Text('Rank',style:GoogleFonts.mcLaren()),
                      title: Center(
                        child: Text('Team',style:GoogleFonts.mcLaren()),
                      ),
                      trailing: Text('Points',style:GoogleFonts.mcLaren()),
                    ),
                    ListTile(
                      title: Text(all_teams_points[index]['Team_Name'],style:GoogleFonts.mcLaren()),
                      trailing: Text(all_teams_points[index]['Points'].toString(),style:GoogleFonts.mcLaren()),
                      leading: Text(same_rank(index).toString(),style: GoogleFonts.mcLaren()),
                      tileColor: Color(0xFFFDD835),
                    ),
                  ],
                );
              }
              return ListTile(
                title: Text(all_teams_points[index]['Team_Name'],style:GoogleFonts.mcLaren()),
                trailing: Text(all_teams_points[index]['Points'].toString(),style:GoogleFonts.mcLaren()),
                leading: (all_teams_points[index-1]['Points']==all_teams_points[index]['Points'])?Text(same_rank(index).toString(),style: GoogleFonts.mcLaren()):Text(diff_rank().toString(),style: GoogleFonts.mcLaren()),
                tileColor: (same_rank(index)==1)?Color(0xFFFDD835):Colors.white,
              );
            },
          ),

          (my_teams.length==0)?Center(child: indicator):ListView.builder(
            itemCount: my_teams.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context,index)
            {
              if(index==0)
              {
                return Column(

                  children: <Widget>[
                    ListTile(
                      title: Center(child: Text('Team Name',style:GoogleFonts.mcLaren())),
                      trailing: Text('Points',style:GoogleFonts.mcLaren()),

                    ),
                    ListTile(
                      title: Text(my_teams[index]['Team_Name'],style:GoogleFonts.mcLaren()),
                      trailing: Text(my_teams[index]['Points'].toString(),style:GoogleFonts.mcLaren()),
                      leading: Text((index+1).toString()),
                    ),
                  ],
                );
              }
              return ListTile(
                title: Text(my_teams[index]['Team_Name'],style:GoogleFonts.mcLaren()),
                trailing: Text(my_teams[index]['Points'].toString(),style:GoogleFonts.mcLaren()),
                leading: Text((index+1).toString()),
              );
            },
          ),
        ],
      ),
    );
  }
}
