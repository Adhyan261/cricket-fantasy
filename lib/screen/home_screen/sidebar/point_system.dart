import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

class Point_system extends StatefulWidget {
  const Point_system({Key? key}) : super(key: key);

  @override
  State<Point_system> createState() => _Point_systemState();
}

class _Point_systemState extends State<Point_system> with TickerProviderStateMixin {

  late TabController tabController;

  List batting = [{'Type':'Run','Points':' +1 '},{'Type':'Four Bonus','Points':' +2 '},{'Type':'Six Bonus','Points':' +3 '},{'Type':'Half Century Bonus','Points':'+10'},{'Type':'Century Bonus','Points':'+20'}];
  List bowling = [{'Type':'Wicket','Points':'+25'},{'Type':'Maiden Over Bonus','Points':'+10'},{'Type':'3 Wicket Bonus','Points':'+15'},{'Type':'5 Wicket Bonus','Points':'+25'}];
  List fielding = [{'Type':'Catch','Points':'+10'},{'Type':'Stumping','Points':'+10'},{'Type':'Run Out','Points':'+10'}];
  @override
  void initState(){
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Points System',style: GoogleFonts.mcLaren()),
        centerTitle: true,
        backgroundColor: Color(0xFF4C52FF),

        bottom: TabBar(
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          labelStyle: GoogleFonts.mcLaren(),
          tabs: [
            Tab(text: 'Batting'),
            Tab(text: 'Bowling'),
            Tab(text: 'Fielding'),
          ],
          controller: tabController,
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children:<Widget>[
          ListView.builder(
            itemCount: batting.length,
            itemBuilder: (context,index){
              if(index==batting.length-1)
                {
                  return Column(
                    children: <Widget>[
                  ListTile(
                    tileColor: (index%2==0)?Colors.white:Colors.grey,
                     title:Text(batting[index]['Type'],style: GoogleFonts.mcLaren(),),
                     trailing: Container(
                     padding: EdgeInsets.all(10),
                     color: Colors.yellow[700],
                     child: Text(batting[index]['Points'])),
                    ),
                      SizedBox(height: 5,),
                      Container(
                        padding: EdgeInsets.all(5),
                          child: Text('*NOTE : If a player scores a century only bonus for the century will be awarded, no half century bonus will be awarded.',
                         style: GoogleFonts.mcLaren())),
                    ],
                  );
                }
              return ListTile(
                tileColor: (index%2==0)?Colors.white:Colors.grey,
                title:Text(batting[index]['Type'],style: GoogleFonts.mcLaren()),
                trailing: Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.yellow[700],
                    child: Text(batting[index]['Points'])),
              );
            },
          ),
          ListView.builder(
            itemCount: bowling.length,
            itemBuilder: (context,index){
              if(bowling.length-1==index)
                {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        tileColor: (index%2==0)?Colors.white:Colors.grey,
                        title:Text(bowling[index]['Type'],style: GoogleFonts.mcLaren(),),
                        trailing: Container(
                            padding: EdgeInsets.all(10),
                            color: Colors.yellow[700],
                            child: Text(bowling[index]['Points'])),
                      ),
                      SizedBox(height: 5,),
                      Container(
                          padding: EdgeInsets.all(5),
                          child: Text('*NOTE : If a player takes 5 wickets only bonus for the 5 wicket haul will be awarded, no 3 wicket haul bonus will be awarded.',
                              style: GoogleFonts.mcLaren())),
                    ],
                  );
                }
              return ListTile(
                tileColor: (index%2==0)?Colors.white:Colors.grey,
                title:Text(bowling[index]['Type'],style: GoogleFonts.mcLaren()),
                trailing: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.yellow[700],
                    child: Text(bowling[index]['Points'])),
              );
            },
          ),
          ListView.builder(
            itemCount: fielding.length,
            itemBuilder: (context,index){
              return ListTile(
                tileColor: (index%2==0)?Colors.white:Colors.grey,
                title:Text(fielding[index]['Type'],style: GoogleFonts.mcLaren()),
                trailing: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.yellow[700],
                    child: Text(fielding[index]['Points'])),
              );
            },
          ),
        ],
      )

    );
  }
}
