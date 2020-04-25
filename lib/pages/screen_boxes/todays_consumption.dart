import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:power_monitor/models/user.dart';
import 'package:provider/provider.dart';

class TodaysConsumption extends StatefulWidget {
  @override
  _TodaysConsumptionState createState() => _TodaysConsumptionState();
}

class _TodaysConsumptionState extends State<TodaysConsumption> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
                  if (docList[i].documentID.trim() == uid.trim()) {
                    doc = docList[i];
                    //print('found!!! userName = ${doc.data['userName']}');
                  } else {
                    //print('wanted doc NOT found!!!');
                  }
                }
                String userName = doc.data['userName'] == null
                    ? 'userName is returning null '
                    : doc.data['userName'];
                print(userName);
                String odometer = doc.data['odometer'] == null
                    ? 'odometer is returning null '
                    : doc.data['odometer'].toString();
                Map historicReads = doc.data['historicReads'];

                int current = int.parse(doc.data['odometer'].toString());

                int currentYear = DateTime.now().year;
                int currentMonth = DateTime.now().month;
                int currentDay = DateTime.now().day;

            //////////////////////////////////////////////////////////////////////////
                List firstLastdates(int currentYear, currentMonth, currentDay) {
                  int maxHour = -1;
                  int minHour = 25;
                  int maxMinute = -1;
                  int minMinute = 61;

                  int year;
                  int month;
                  int day;
                  int hour;
                  int minute;

                  int cDay = (currentMonth == 2) && (currentDay > 28) ? 28 : currentDay;

                  historicReads.forEach((key, value) {
                    year = (int.parse(key.toString()) / 100000000).toInt();
                    month = ((int.parse(key.toString()) / 1000000) % 100).toInt();
                    day = ((int.parse(key.toString()) / 10000) % 100).toInt();
                    hour = ((int.parse(key.toString()) / 100) % 100).toInt();
                    minute = ((int.parse(key.toString())) % 100).toInt();
                    if (year == currentYear && month == currentMonth && day == cDay) {
                      if (hour < minHour) minHour = hour;
                      if (hour > maxHour) maxHour = hour;
                    }
                  });
                  historicReads.forEach((key, value) {
                    year = (int.parse(key.toString()) / 100000000).toInt();
                    month = ((int.parse(key.toString()) / 1000000) % 100).toInt();
                    day = ((int.parse(key.toString()) / 10000) % 100).toInt();
                    hour = ((int.parse(key.toString()) / 100) % 100).toInt();
                    minute = ((int.parse(key.toString())) % 100).toInt();
                    if (year == currentYear && month == currentMonth && day == cDay) {
                      if (hour == minHour && minute < minMinute) minMinute = minute;
                      if (hour == maxHour && minute > maxMinute) maxMinute = minute;
                    }
                  });
                  int firstReadOfDayDate = (currentYear * 100000000) +
                      (currentMonth * 1000000) +
                      (cDay * 10000) +
                      (minHour * 100) +
                      minMinute;
                  int lastReadOfDayDate = (currentYear * 100000000) +
                      (currentMonth * 1000000) +
                      (cDay * 10000) +
                      (maxHour * 100) +
                      maxMinute;
                  return [firstReadOfDayDate, lastReadOfDayDate];
                }
        //////////////////////////////////////////////////////////////////////////////////////////
                String firstReadDate = firstLastdates(currentYear, currentMonth, currentDay)[0].toString();
                //String lastReadDate = firstLastdates(currentYear, currentMonth, currentDay)[1].toString();

                int firstReadOfDay = historicReads[firstReadDate] == null ? 0 : historicReads[firstReadDate];

                int todaysConsumption =  historicReads[firstReadDate] == null ? 0 :current - firstReadOfDay;

                double firstReadHour = ((((double.parse(firstReadDate)).toDouble())/100)%100);
                double firstReadMinute = (((double.parse(firstReadDate)).toDouble())%100);


                return new Text(
                    firstReadHour == 25 || firstReadMinute == 61
                        ? 'no reads today'
                        : todaysConsumption.toString() + ' kwh',
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
