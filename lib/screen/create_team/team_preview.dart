import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../../data/data.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Team_preview extends StatelessWidget {

  final List<String> batsmen;
  final List<String> bowlers;
  final List<String> wicketkeeper;
  final List<String> allrounders;


  const Team_preview({required this.batsmen,required this.bowlers,required this.allrounders,required this.wicketkeeper});

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
                    for(int i=0;i<wicketkeeper.length;i++)
                      player_icon(player: wicketkeeper, i: i,player_type: 'wk',),
                  ],
                ),

                SizedBox(height:8),

                Text('Batsmen',
                style: GoogleFonts.mcLaren()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  for(int i=0;i<batsmen.length;i++)
                  player_icon(player: batsmen, i: i,player_type: 'bat',),
                ],
              ),

              SizedBox(height:8),

              Text('All-rounders',
                  style: GoogleFonts.mcLaren()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  for(int i=0;i<allrounders.length;i++)
                    player_icon(player: allrounders, i: i,player_type: 'bat_ball',),
                ],
              ),

              SizedBox(height:8),

              Text('Bowlers',
                  style: GoogleFonts.mcLaren()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  for(int i=0;i<bowlers.length;i++)
                    player_icon(player: bowlers, i: i,player_type: 'ball',),
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
  }) : super(key: key);

  final List<String> player;
  final int i;
  final String player_type;

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
          ),
        ),
        Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            player[i],
            style: GoogleFonts.mcLaren(
              fontSize: 6,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}


