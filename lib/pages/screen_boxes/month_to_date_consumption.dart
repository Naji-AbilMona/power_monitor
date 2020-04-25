import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:power_monitor/models/user.dart';
import 'package:provider/provider.dart';

class MonthToDateConsumption extends StatefulWidget {
  @override
  _MonthToDateConsumptionState createState() => _MonthToDateConsumptionState();
}

class _MonthToDateConsumptionState extends State<MonthToDateConsumption> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          'Month-to-Date\nConsumption',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Color(0xffffa500),
          ),
        ),
        SizedBox(height: 8),
        new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('consumption').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return new Text('Error: ${snapshot.error}');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                final user = Provider.of<User>(context);
                String uid = user.email.trim();
                var docList = snapshot.data.documents;
                var doc;

                for (int i = 0; i < docList.length; i++) {
                  if (docList[i].documentID.trim() == uid.trim()) doc = docList[i];
                }

                Map historicReads = doc.data['historicReads'];

                int current = int.parse(doc.data['odometer'].toString());
                int year;
                int month;
                int day;
                int hour;
                int minute;
                int currentYear = DateTime.now().year;
                int currentMonth = DateTime.now().month;
                int firstReadHour = 25;
                int firstReadMinute = 61;
                int firstReadDayInMonth = 32;

                historicReads.forEach((key, value) {
                  year = (int.parse(key.toString()) / 100000000).toInt();
                  month = ((int.parse(key.toString()) / 1000000) % 100).toInt();
                  day = ((int.parse(key.toString()) / 10000) % 100).toInt();
                  hour = ((int.parse(key.toString()) / 100) % 100).toInt();
                  minute = ((int.parse(key.toString())) % 100).toInt();

                  if ((year == currentYear) && (month == currentMonth)) {
                    if (day < firstReadDayInMonth) firstReadDayInMonth = day;
                  }
                });
                historicReads.forEach((key, value) {
                  year = (int.parse(key.toString()) / 100000000).toInt();
                  month = ((int.parse(key.toString()) / 1000000) % 100).toInt();
                  day = ((int.parse(key.toString()) / 10000) % 100).toInt();
                  hour = ((int.parse(key.toString()) / 100) % 100).toInt();
                  minute = ((int.parse(key.toString())) % 100).toInt();

                  if ((year == currentYear) &&
                      (month == currentMonth) &&
                      (day == firstReadDayInMonth)) {
                    if (hour <= firstReadHour) firstReadHour = hour;
                    if (hour == firstReadHour) {
                      if (minute <= firstReadMinute) firstReadMinute = minute;
                    }
                  }
                });

                int firstReadOfMonthDate = (currentYear * 100000000) +
                    (currentMonth * 1000000) +
                    (firstReadDayInMonth * 10000) +
                    (firstReadHour * 100) +
                    firstReadMinute;

                int firstReadOfMonth =
                    (firstReadHour == 25 || firstReadMinute == 61 || firstReadDayInMonth == 32)
                        ? 0
                        : historicReads[firstReadOfMonthDate.toString()];

                int monthToDateConsumption = current - firstReadOfMonth;

                return new Text(
                    firstReadHour == 25 || firstReadMinute == 61
                        ? 'no reads this month'
                        : monthToDateConsumption.toString() + ' kwh',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      wordSpacing: 2,
                      color: Colors.grey[200],
                    ));
            }
          },
        ),
      ],
    );
  }
}
