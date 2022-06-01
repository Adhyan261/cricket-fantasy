import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:win_fantasy11/screen/home_screen/home_screen.dart';

class team_view extends StatefulWidget {
  team_view({
    Key? key,
    required this.captain,
    required this.value,
    required this.vice_captain,
    required this.total_points,
    required this.points,
    required this.wicketkeepers,
    required this.batsmen,
    required this.allrounders,
    required this.bowlers,
  }) : super(key: key);

  final String captain;
  final List value;
  final String vice_captain;
  late  double total_points;
  final Map<String,dynamic> points;
  final List wicketkeepers;
  final List batsmen;
  final List allrounders;
  final List bowlers;

  @override
  State<team_view> createState() => _team_viewState();
}

class _team_viewState extends State<team_view> {

  Text get_points(int index)
  {
    if(widget.value[index]==widget.captain)
    {
      widget.total_points = widget.total_points + (((widget.points[widget.value[index]])!=null)?(2*(widget.points[widget.value[index]])):0);
      return (widget.points[widget.value[index]]!=null)?Text((2*(widget.points[widget.value[index]])).toString()):Text('0');
    }
    else if(widget.value[index]==widget.vice_captain)
    {
      widget.total_points = widget.total_points + (((widget.points[widget.value[index]])!=null)?(1.5*(widget.points[widget.value[index]])):0);
      return (widget.points[widget.value[index]]!=null)?Text((1.5*(widget.points[widget.value[index]])).toString()):Text('0');
    }
    else
    {
      widget.total_points = widget.total_points + (((widget.points[widget.value[index]])!=null)?(widget.points[widget.value[index]]):0);
      return (widget.points[widget.value[index]]!=null)?Text((widget.points[widget.value[index]]).toString()):Text('0');
    }
  }

  CircleAvatar get_image(int index)
  {
    if(widget.batsmen.contains(widget.value[index]))
      {
        return CircleAvatar(
          backgroundColor: Colors.white,
          radius: 20,
          backgroundImage: AssetImage(
              'images/bat.jpg'),
        );
      }
    else if(widget.wicketkeepers.contains(widget.value[index]))
      {
        return CircleAvatar(
          backgroundColor: Colors.white,
          radius: 20,
          backgroundImage: AssetImage(
              'images/wk.jpg'),
        );
      }
    else if(widget.allrounders.contains(widget.value[index]))
    {
      return CircleAvatar(
        backgroundColor: Colors.white,
        radius: 20,
        backgroundImage: AssetImage(
            'images/bat_ball.jpg'),
      );
    }
    else
    {
      return CircleAvatar(
        backgroundColor: Colors.white,
        radius: 20,
        backgroundImage: AssetImage(
            'images/ball.jpg'),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4C52FF),
        title: Text(
          'Fantasy Team',
          style: GoogleFonts.mcLaren(),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: ListView.builder(
          itemCount: 11,
          itemBuilder: (context,index)
          {
            if(index==0)
            {
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text('Player',
                      style: GoogleFonts.mcLaren(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                    trailing: Text('Points',
                      style: GoogleFonts.mcLaren(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title:(widget.captain==widget.value[index])?Text('${widget.value[index]} (C) ',style: GoogleFonts.mcLaren(fontSize: 15),):((widget.vice_captain==widget.value[index])?Text('${widget.value[index]} (VC) ',style: GoogleFonts.mcLaren(fontSize: 15),):Text(widget.value[index],style: GoogleFonts.mcLaren(fontSize: 15),)),
                      trailing: get_points(index),
                      leading:  get_image(index),
                    ),
                  ),
                ],
              );
            }
            else if(index==10)
            {
              return Column(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      title:(widget.captain==widget.value[index])?Text('${widget.value[index]} (C) ',style: GoogleFonts.mcLaren(fontSize: 15),):((widget.vice_captain==widget.value[index])?Text('${widget.value[index]} (VC) ',style: GoogleFonts.mcLaren(fontSize: 15),):Text(widget.value[index],style: GoogleFonts.mcLaren(fontSize: 15),)),
                      trailing: get_points(index),
                      leading: get_image(index),
                    ),
                  ),
                  ListTile(
                    title: Text('Total Points',
                      style: GoogleFonts.mcLaren(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                    trailing: Text(widget.total_points.toString(),
                      style: GoogleFonts.mcLaren(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                  ),
                ],
              );
            }
            else
            {
              return Card(
                child: ListTile(
                  title:
                  (widget.captain==widget.value[index])?Text('${widget.value[index]} (C) ',style: GoogleFonts.mcLaren(fontSize: 15),):((widget.vice_captain==widget.value[index])?Text('${widget.value[index]} (VC) ',style: GoogleFonts.mcLaren(fontSize: 15),):Text(widget.value[index],style: GoogleFonts.mcLaren(fontSize: 15),)),
                  trailing: get_points(index),
                  leading: get_image(index),
                ),
              );
            }
          }
      ),
    );
  }
}