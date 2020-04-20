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
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                String t = docList[0].documentID;
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
                    : doc.data['odometer'];
                Map historicReads = doc.data['historicReads'];
                print(historicReads);
                historicReads.forEach((key, value) {});







                return new Text(odometer == null ? 'null!!' : odometer + ' kw',
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
