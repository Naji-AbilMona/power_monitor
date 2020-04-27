import 'package:flutter/material.dart';
import 'package:power_monitor/pages/ElectrisityBill.dart';
import 'package:power_monitor/pages/screen_boxes/current_odometer.dart';
import 'package:power_monitor/pages/screen_boxes/graph_consumption.dart';
import 'package:power_monitor/pages/screen_boxes/todays_consumption.dart';
import 'package:power_monitor/pages/screen_boxes/month_to_date_consumption.dart';
import 'package:power_monitor/services/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //for logout
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        title: Text('Power Monitor'),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              await _auth.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white70,
            ),
            label: Text('logout'),
          )
        ],
      ),
      body: Container(
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
            RaisedButton(
              color: Colors.black12,
              child: Text(
                'Electrisity Bill',
                style: TextStyle(color: Colors.white70),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ElectrisityBill()),
                );
              },
            ),
            SizedBox(height: screenHeight / 40),
            Padding(
              padding: const EdgeInsets.all(0),
              child: CurrentOdometer(),
            ),
            SizedBox(height: screenHeight / 26), //80 - emu 50
            Container(
              color: Colors.white10,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TodaysConsumption(),
                  ),
                  Expanded(
                    child: MonthToDateConsumption(),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight / 12), //110 - emu 70
            Container(
              child: GraphConsumption(),
            ),
            SizedBox(height: screenHeight / 40), //110 - emu 70
          ],
        ),
      ),
    );
  }
}
