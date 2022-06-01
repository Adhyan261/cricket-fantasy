import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:win_fantasy11/data/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:win_fantasy11/data/set_data.dart';
import 'my_matches_contests_joined.dart';

class My_contest extends StatefulWidget {
  const My_contest({Key? key}) : super(key: key);

  @override
  State<My_contest> createState() => _My_contestState();
}

class _My_contestState extends State<My_contest> {

  @override
  void initState() {
    super.initState();
    update();
  }

  Set_Data data =Set_Data();
  Match_data match = Match_data();
  CircularProgressIndicator indicator = CircularProgressIndicator(backgroundColor: Colors.grey,color: Colors.blueAccent,strokeWidth: 6,);

  List contests = [];
  List L = [];

  Future update() async
  {
    contests = await data.get_joined_contest();
    for(int i=0;i<contests.length;i++)
    {
      final list = await match.get_home_page_data(contests[i].toString());
      L.add(list);
    }
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF4C52FF),Colors.grey.shade600],
          ),
        ),
        child: (L.length==0)?Center(child: indicator):ListView.builder(
          itemCount: L.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context,index)
    {
         return Padding(
          padding: const EdgeInsets.all(10.0),
          child: match_details( team_1: L[index][0], team_2: L[index][1], status: L[index][2],start_time: L[index][3],day_night: L[index][4],match_id:contests[index].toString(),series_name:L[index][5]),
        );
    }
        ),
      ),
    );
  }
}

class match_details extends StatefulWidget {
  const match_details({
    Key? key,
    required this.status,
    required this.team_1,
    required this.team_2,
    required this.day_night,
    required this.start_time,
    required this.match_id,
    required this.series_name,
  }) : super(key: key);

  final String status;
  final String team_1;
  final String team_2;
  final String day_night;
  final String start_time;
  final String match_id;
  final String series_name;
  @override
  State<match_details> createState() => _match_detailsState();
}

class _match_detailsState extends State<match_details> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder:(context)=>My_contest_joined(match_id: widget.match_id,team1:widget.team_1,team2:widget.team_2)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.fiber_manual_record,
                    size: 15,
                    color: (widget.status=='FINISHED')?Colors.red[800]:Colors.green[800],
                  ),
                  SizedBox(width: 5,),
                  Text(
                    widget.status,
                    style: GoogleFonts.mcLaren(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5,),
              Center(
                child: Text(
                  widget.series_name,
                  style: GoogleFonts.mcLaren(
                    color: Colors.blue,
                    fontSize: 10,
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('images/${widget.team_1.toLowerCase()}.jpg'),
                  ),
                  Text(
                    widget.team_1,
                    style: GoogleFonts.mcLaren(),
                  ),
                  Text(
                    'VS',
                    style: GoogleFonts.mcLaren(),
                  ),
                  Text(
                    widget.team_2,
                    style: GoogleFonts.mcLaren(),
                  ),
                  CircleAvatar(
                    radius:30,
                    backgroundImage: AssetImage('images/${widget.team_2.toLowerCase()}.jpg'),
                  ),
                ],
              ),
              SizedBox(height: 5,),
              Center(
                child: Text(
                  'Match date : ${widget.start_time.substring(0,10)}',
                  style: GoogleFonts.mcLaren(
                    fontSize: 10,
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