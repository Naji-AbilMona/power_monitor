import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:power_monitor/models/user.dart';
import 'package:provider/provider.dart';

class CurrentOdometer extends StatefulWidget {
  @override
  _CurrentOdometerState createState() => _CurrentOdometerState();
}

class _CurrentOdometerState extends State<CurrentOdometer> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    print('height is $h and width is $w');
    return Column(
      children: <Widget>[
        Text(
          'Your Current Odometer',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: h/29,
            color: Color(0xffffa500),
          ),
        ),
        SizedBox(height: h/91),
        new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('consumption').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              print('Error: ${snapshot.error}');
              return new Text('Loading...');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading....');
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
                //print(userName);
                String odometer = doc.data['odometer'] == null
                    ? 'odometer is returning null '
                    : doc.data['odometer'].toString();
                //print(odometer + 'kw');
                String timeStamp = doc.data['timeStamp'] == null ? 'null' : doc.data['timeStamp'];
                //print('timeStamp: ${timeStamp.toDate()}');

                return Column(
                  children: <Widget>[
                    new Text(odometer == null ? 'null!!' : odometer + ' kwh',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: h/21,
                          wordSpacing: 2,
                          color: Colors.grey[200],
                        )),
                    SizedBox(height: h/87),
                    Text(
                      'last read was done at: ${timeStamp}',
                      style: TextStyle(
                        color: Colors.grey[200],
                      ),
                    ),
                  ],
                );
            }
          },
        ),
      ],
    );
  }
}
