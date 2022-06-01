import 'dart:ffi';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../../data/data.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Saved_team_preview extends StatefulWidget {
  final String captain;
  final List value;
  final String vice_captain;
  late  double total_points;
  final Map<String,dynamic> points;
  final List wicketkeepers;
  final List batsmen;
  final List allrounders;
  final List bowlers;

  Saved_team_preview({required this.value,required this.total_points,required this.points,required this.vice_captain,required this.captain,required this.wicketkeepers,required this.batsmen,required this.allrounders, required this.bowlers});

  @override
  State<Saved_team_preview> createState() => _Saved_team_previewState();
}

class _Saved_team_previewState extends State<Saved_team_preview> {

  TextStyle points_style = GoogleFonts.mcLaren(color: Colors.white,fontSize: 10);

  Text get_points(String player)
  {
    if(player==widget.captain)
    {
      widget.total_points = widget.total_points + (((widget.points[player])!=null)?(2*(widget.points[player])):0);
      return (widget.points[player]!=null)?Text(((2*(widget.points[player])).toString())+' pts',style: points_style,):Text('0 pts',style: points_style,);
    }
    else if(player==widget.vice_captain)
    {
      widget.total_points = widget.total_points + (((widget.points[player])!=null)?(1.5*(widget.points[player])):0);
      return (widget.points[player]!=null)?Text(((1.5*(widget.points[player])).toString())+' pts',style: points_style,):Text('0 pts',style: points_style,);
    }
    else
    {
      widget.total_points = widget.total_points + (((widget.points[player])!=null)?(widget.points[player]):0);
      return (widget.points[player]!=null)?Text(((widget.points[player]).toString())+' pts',style: points_style,):Text('0 pts',style: points_style,);
    }
  }

  bool get_captain(String player)
  {
    if(player == widget.captain)
      return true;
    else
      return false;
  }

  bool get_vice_captain(String player)
  {
    if(player == widget.vice_captain)
      return true;
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Team Preview',
          style: GoogleFonts.mcLaren(),
        ),
        centerTitle: true,
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/ground.jpg"),
              fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('Wicketkeeper',
                style: GoogleFonts.mcLaren(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  for(int i=0;i<widget.wicketkeepers.length;i++)
                    player_icon(player: widget.wicketkeepers, i: i,player_type: 'wk',points: get_points(widget.wicketkeepers[i]),captain: get_captain(widget.wicketkeepers[i]),vice_captain: get_vice_captain(widget.wicketkeepers[i]),),
                ],
              ),
              SizedBox(height:8),

              Text('Batsmen',
                  style: GoogleFonts.mcLaren()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  for(int i=0;i<widget.batsmen.length;i++)
                    player_icon(player: widget.batsmen, i: i,player_type: 'bat', points:get_points(widget.batsmen[i]),captain: get_captain(widget.batsmen[i]),vice_captain: get_vice_captain(widget.batsmen[i])),
                ],
              ),

              SizedBox(height:8),

              Text('All-rounders',
                  style: GoogleFonts.mcLaren()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  for(int i=0;i<widget.allrounders.length;i++)
                    player_icon(player: widget.allrounders, i: i,player_type: 'bat_ball', points:get_points(widget.allrounders[i]),captain: get_captain(widget.allrounders[i]),vice_captain: get_vice_captain(widget.allrounders[i])),
                ],
              ),

              SizedBox(height:8),

              Text('Bowlers',
                  style: GoogleFonts.mcLaren()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  for(int i=0;i<widget.bowlers.length;i++)
                    player_icon(player: widget.bowlers, i: i,player_type: 'ball', points:get_points(widget.bowlers[i]),captain: get_captain(widget.bowlers[i]),vice_captain: get_vice_captain(widget.bowlers[i])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class player_icon extends StatelessWidget {
  const player_icon({
    Key? key,
    required this.player,
    required this.i,
    required this.player_type,
    required this.points,
    required this.captain,
    required this.vice_captain,
  }) : super(key: key);

  final List player;
  final int i;
  final String player_type;
  final Text points;
  final bool captain;
  final bool vice_captain;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(5),
          child: CircleAvatar(
            backgroundImage: AssetImage('images/$player_type.jpg'),
            backgroundColor: Colors.white,
            radius: 20,
            child: (captain||vice_captain)?Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment(1.5,-2.2),
                  child: CircleAvatar(
                    backgroundColor: Colors.red[700],
                    radius: 10,
                    child: Center(child: (captain)?Text('C',style: GoogleFonts.mcLaren(fontSize: 10),):Text('VC',style: GoogleFonts.mcLaren(fontSize: 8))
                      ,),
                  ),
                ),
              ],
            ):Text(''),
          ),
        ),
        Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: <Widget>[
              Text(
                player[i],
                style: GoogleFonts.mcLaren(
                  fontSize: 6,
                  color: Colors.white,
                ),
              ),
              points,
            ],
          ),
        ),
      ],
    );
  }
}