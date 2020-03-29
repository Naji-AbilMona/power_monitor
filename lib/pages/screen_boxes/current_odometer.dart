import 'package:flutter/material.dart';

class CurrentOdometer extends StatefulWidget {
  @override
  _CurrentOdometerState createState() => _CurrentOdometerState();
}

class _CurrentOdometerState extends State<CurrentOdometer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 5),
          Text(
            'Your current electricity Odometer is:',
            style: TextStyle(color: Colors.grey[200], fontSize: 15),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            '123456 Kw',
            style: TextStyle(
              fontSize: 38,
              wordSpacing: 2,
              color: Color(0xffffa500),
              //fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Last read was done at: 16:00h',
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
