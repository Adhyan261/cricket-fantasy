import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:win_fantasy11/data/data.dart';
import 'team_preview.dart';
import 'save_team.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';


class Create_team extends StatefulWidget {

  final String team1;
  final String team2;
  final String match_id;
  final String start_time;
  Create_team({required this.team1,required this.team2,required this.match_id,required this.start_time});

  @override
  State<Create_team> createState() => _Create_teamState();
}

class _Create_teamState extends State<Create_team> with TickerProviderStateMixin {

  Match_data match = Match_data();

  late TabController tabController;

  late List<bool> _color_batsmen = List.filled(30,false,growable: false);
  late List<bool> _color_bowler = List.filled(30,false,growable: false);
  late List<bool> _color_wk = List.filled(30,false,growable: false);
  late List<bool> _color_allrounder = List.filled(30,false,growable: false);

  late List<String> _batsmen_selected = List.filled(0,'',growable: true);
  late List<String> _bowler_selected = List.filled(0,'',growable: true);
  late List<String> _wk_selected = List.filled(0,'',growable: true);
  late List<String> _allrounder_selected = List.filled(0,'',growable: true);

  late int _wk_count = 0;
  late int _bowler_count = 0;
  late int _batsmen_count = 0;
  late int _allrounder_count = 0;
  late int _total_players = 0;

  CircularProgressIndicator indicator = CircularProgressIndicator(backgroundColor: Colors.grey,color: Colors.blueAccent,strokeWidth: 6,);

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    super.initState();
    get_players();
  }

  late List<String> batsmen = [];
  late List<String> bowlers = [];
  late List<String> allrounders = [];
  late List<String> wicketkeepers = [];

  Future get_players() async {
    final players_list = await match.get_players_list(widget.match_id);
    batsmen = players_list['batsmen'];
    bowlers = players_list['bowlers'];
    wicketkeepers = players_list['wicketkeepers'];
    allrounders = players_list['allrounders'];
    setState(() {});
  }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Column(
          children: <Widget>[
            Text('Create Team',
              style: GoogleFonts.mcLaren(
                fontSize: 20,
              ),
            ),
            Text(
              '${widget.team1} VS ${widget.team2}',
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
        child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              Column(
                  children: <Widget>[
                    Card(
                      elevation: 0.5,
                      margin: EdgeInsets.all(5),
                      child: Column(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  'Start time : ${widget.start_time} at 7:30 pm',
                                  style: GoogleFonts.mcLaren(
                                    color: Colors.grey,
                                  ),
                                )),

                            Container(
                                padding: EdgeInsets.all(5),
                                child: Row(children: <Widget>[
                                  Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        Container(
                                            child: Text('Players',
                                              style: GoogleFonts.mcLaren(),
                                            )),
                                        Text(
                                          '$_total_players/11',
                                          style: GoogleFonts.mcLaren(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ]
                                  ),
                                  Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundImage: AssetImage(''
                                                'images/${widget.team1.toLowerCase()}.jpg'),
                                          ),
                                          Text('  VS  ',
                                              style: GoogleFonts.mcLaren()),
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundImage: AssetImage('images/${widget.team2.toLowerCase()}.jpg'),
                                          ),
                                        ],
                                      )
                                  ),
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .end,
                                      children: <Widget>[
                                        Text('Credits left',
                                          style: GoogleFonts.mcLaren(),
                                        ),
                                        Text('100',
                                          style: GoogleFonts.mcLaren(),
                                        ),

                                      ]
                                  ),
                                ]
                                )
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.fromLTRB(20,10,20,10),
                              child: StepProgressIndicator(
                                totalSteps: 11,
                                currentStep: _total_players,
                                size:10,
                                selectedColor: Color(0xFF4C52FF),
                                unselectedColor: (Colors.grey[300])!,
                              ),
                            ),
                            Container(
                              height: 20,
                              width: double.infinity,
                              padding: EdgeInsets.all(5),)
                          ]
                      ),
                    ),

                    Container(
                        height: 40,
                        child: TabBar(
                          unselectedLabelColor: Colors.black54,
                          indicatorColor: Color(0xFF4C52FF),
                          labelColor: Color(0xFF4C52FF),
                          labelStyle: GoogleFonts.mcLaren(),
                          tabs: [
                            Tab(text: 'WK'),
                            Tab(text: 'BAT'),
                            Tab(text: 'AR'),
                            Tab(text: 'BOWL')
                          ],
                          controller: tabController,
                        )),
                    Flexible(
                        child: TabBarView(
                            physics: BouncingScrollPhysics(
                              parent: PageScrollPhysics(),
                            ),
                            controller: tabController,
                            children: <Widget>[
                              (wicketkeepers.length==0)?Center(child:indicator):
                              ListView.builder(
                                itemCount: wicketkeepers.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(wicketkeepers[index],
                                      style: GoogleFonts.mcLaren(),),
                                    tileColor: (_color_wk[index])?Colors.blue:Colors.white,
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 20,
                                      backgroundImage: AssetImage(
                                          'images/wk.jpg'),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        if(_wk_count<2&&_color_wk[index]==false&&_total_players<11){
                                          _color_wk[index] = !_color_wk[index];
                                          _wk_count = _wk_count+1;
                                          _total_players = _total_players+1;
                                          _wk_selected.add(wicketkeepers[index]);
                                        }
                                        else if(_color_wk[index]==true)
                                        {
                                          _color_wk[index] = !_color_wk[index];
                                          _wk_count = _wk_count-1;
                                          _total_players = _total_players-1;
                                          _wk_selected.removeWhere((item) => item==wicketkeepers[index]);
                                        }
                                      });
                                    },
                                  );
                                },
                              ),
                              (batsmen.length==0)?Center(child:indicator):ListView.builder(
                                itemCount: batsmen.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(batsmen[index],
                                      style: GoogleFonts.mcLaren(),),
                                    tileColor: (_color_batsmen[index])?Colors.blue:Colors.white,
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 20,
                                      backgroundImage: AssetImage(
                                          'images/bat.jpg'),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        if(_batsmen_count<5&&_color_batsmen[index]==false&&_total_players<11){
                                          _color_batsmen[index] = !_color_batsmen[index];
                                          _batsmen_count = _batsmen_count+1;
                                          _total_players = _total_players+1;
                                          _batsmen_selected.add(batsmen[index]);
                                        }
                                        else if(_color_batsmen[index]==true)
                                        {
                                          _color_batsmen[index] = !_color_batsmen[index];
                                          _batsmen_count = _batsmen_count-1;
                                          _total_players = _total_players-1;
                                          _batsmen_selected.removeWhere((item) => item==(batsmen[index]));
                                        }
                                      });
                                    },
                                  );
                                },
                              ),
                              (allrounders.length==0)?Center(child:indicator):ListView.builder(
                                itemCount: allrounders.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(allrounders[index],
                                      style: GoogleFonts.mcLaren(),),
                                    tileColor: (_color_allrounder[index])?Colors.blue:Colors.white,
                                    leading: CircleAvatar(
                                      backgroundColor:Colors.white,
                                      radius: 20,
                                      backgroundImage: AssetImage(
                                          'images/bat_ball.jpg'),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        if(_allrounder_count<3&&_color_allrounder[index]==false&&_total_players<11){
                                          _color_allrounder[index] = !_color_allrounder[index];
                                          _allrounder_count = _allrounder_count+1;
                                          _total_players = _total_players+1;
                                          _allrounder_selected.add(allrounders[index]);
                                        }
                                        else if(_color_allrounder[index]==true)
                                        {
                                          _color_allrounder[index] = !_color_allrounder[index];
                                          _allrounder_count = _allrounder_count-1;
                                          _total_players = _total_players -1;
                                          _allrounder_selected.removeWhere((item) => item==(allrounders[index]));
                                        }
                                      });
                                    },
                                  );
                                },
                              ),
                              (bowlers.length==0)?Center(child:indicator):ListView.builder(
                                itemCount: bowlers.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(bowlers[index],
                                      style: GoogleFonts.mcLaren(),
                                    ),
                                    tileColor: (_color_bowler[index])?Colors.blue:Colors.white,
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 20,
                                      backgroundImage: AssetImage(
                                          'images/ball.jpg'),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        if(_bowler_count<5&&_color_bowler[index]==false&&_total_players<11){
                                          _color_bowler[index] = !_color_bowler[index];
                                          _bowler_count = _bowler_count+1;
                                          _total_players = _total_players+1;
                                          _bowler_selected.add(bowlers[index]);
                                        }
                                        else if(_color_bowler[index]==true)
                                        {
                                          _color_bowler[index] = !_color_bowler[index];
                                          _bowler_count = _bowler_count-1;
                                          _total_players = _total_players-1;
                                          _bowler_selected.removeWhere((item) => item==(bowlers[index]));
                                        }
                                      });
                                    },
                                  );
                                },
                              ),
                            ]
                        )
                    )
                  ]
              )
            ]
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,

        child:Row(
          children: <Widget>[
            Container(
              child: FlatButton(
                color: Color(0xFF4C52FF),
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Team_preview(batsmen: _batsmen_selected,bowlers: _bowler_selected,
                    allrounders: _allrounder_selected,wicketkeeper: _wk_selected,)));
                  //print(allrounder_selected.length+batsmen_selected.length+bowler_selected.length+wk_selected.length);
                  //print(batsmen_selected);
                },
                child: Center(child: Text('Preview Team',
                  style: GoogleFonts.mcLaren(
                      fontSize: 20,
                      color: Colors.white
                  ),
                )),
              ),
            ),
            Expanded(
              child: FlatButton(
                color: Colors.blueGrey,
                onPressed: (){
                  if(_total_players!=11)
                  {
                    showToast('Plaese Select 11 Players');
                  }
                  else if(_wk_selected.length==0)
                    {
                      showToast('Atleast 1 Wicketkeeper should be selected');
                    }
                  else if(_bowler_selected.length==0)
                    {
                      showToast('Atleast 1 Bowler should be selected');
                    }
                  else if(_batsmen_selected.length==0)
                    {
                      showToast('Atleast 1 Batsman should be selected');
                    }
                  else if(_allrounder_selected.length==0)
                    {
                      showToast('Atleast 1 Allrounder should be selected');
                    }
                  else
                    {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>Save_team(batsmen: _batsmen_selected,bowlers: _bowler_selected,
                          allrounders: _allrounder_selected,wicketkeeper: _wk_selected,match_id:widget.match_id,team1:widget.team1,team2:widget.team2,start_time:widget.start_time)));
                    }
                },
                child: Center(child: Text('Next',
                  style: GoogleFonts.mcLaren(
                      fontSize: 20,
                      color: Colors.white
                  ),
                )),
              ),
            ),
          ],
        ),

      ),
    );
  }
}

