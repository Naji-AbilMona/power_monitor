import 'package:flutter/material.dart';
import 'package:power_monitor/pages/about.dart';
import 'package:power_monitor/pages/screen_boxes/current_odometer.dart';
import 'package:power_monitor/pages/screen_boxes/graph_consumption.dart';
import 'package:power_monitor/pages/screen_boxes/todays_consumption.dart';
import 'package:power_monitor/pages/screen_boxes/month_to_date_consumption.dart';
//import 'package:power_monitor/pages/screen_boxes/graph_consumption.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //initiate a Map for data like so:
  //Map data = {};
  //double width = MediaQuery.of(context).size.width; get the size of the screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[900],
          title: Text('Power Monitor'),
          centerTitle: true,
          elevation: 0,
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => About()),
                );
              },
              icon: Icon(
                Icons.people,
                color: Colors.white70,
              ),
              label: Text(''),
            )
          ],
        ),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/digital.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CurrentOdometer(),
                ),
                SizedBox(height: (MediaQuery.of(context).size.height)/8.7), //80 - emu 50
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TodaysConsumption(),
                    ),
                    Expanded(
                      child: MonthToDateConsumption(),
                    ),
                  ],
                ),
                SizedBox(height: (MediaQuery.of(context).size.height)/5.5), //110 - emu 70
                Container(
                  child: GraphConsumption(),
                ),
              ],
            ),
          ),
        ));
  }
}
