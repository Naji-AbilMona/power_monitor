import 'package:flutter/material.dart';


class MonthToDateConsumption extends StatefulWidget {
  @override
  _MonthToDateConsumptionState createState() => _MonthToDateConsumptionState();
}

class _MonthToDateConsumptionState extends State<MonthToDateConsumption> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            'Month to Date\nConsumption',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Color(0xffffa500),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '12344 Kw',
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
