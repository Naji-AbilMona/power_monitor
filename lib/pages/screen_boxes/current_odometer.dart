import 'package:flutter/material.dart';
import 'package:power_monitor/data/electricity_usage.dart';
import 'package:power_monitor/services/auth.dart';
import 'package:power_monitor/services/database.dart';

class CurrentOdometer extends StatefulWidget {
  @override
  _CurrentOdometerState createState() => _CurrentOdometerState();
}

class _CurrentOdometerState extends State<CurrentOdometer> {
  //ElectricityUsage electricityUsage = ElectricityUsage(odometer: 'init: no reads yet', time: 'N/A');
  //DatabaseService data = DatabaseService(odometer: 'init: no reads yet', time: 'N/A');
  AuthService data = AuthService(usage: 'init error', time: 'init error');
  //String usage = AuthService().getUsage;
  //String time = AuthService().getTime;
  String usage = DatabaseService().usage;
  String time = DatabaseService().timeData;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 5),
          Text(
            'Your current electricity Odometer is:',
            style: TextStyle(color: Colors.grey[200], fontSize: 14),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'no reads yet',
            //data.getUsage + ' kw',
            //usage,
            style: TextStyle(
              fontSize: 38,
              wordSpacing: 2,
              color: Color(0xffffa500),
              ////fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            //'Last read was done at: ' + data.getTime,
            //time,
            'error in reading',
            style: TextStyle(
              color: Colors.grey[200],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
