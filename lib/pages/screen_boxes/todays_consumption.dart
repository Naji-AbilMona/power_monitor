import 'package:flutter/material.dart';

class TodaysConsumption extends StatefulWidget {
  @override
  _TodaysConsumptionState createState() => _TodaysConsumptionState();
}

class _TodaysConsumptionState extends State<TodaysConsumption> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            'Today\'s\nConsumption',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Color(0xffffa500),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '1234 Kw',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              wordSpacing: 2,
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
