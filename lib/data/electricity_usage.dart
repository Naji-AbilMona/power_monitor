import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'
    as https; //dart package: Future-based library for making HTTP requests. https://pub.dev/packages/http
import 'dart:convert'; //dart library: Encoders and decoders for converting between different data representations, including JSON and UTF-8. https://api.dart.dev/stable/2.7.1/dart-convert/dart-convert-library.html
import 'package:intl/intl.dart'; //dart date format package. https://pub.dev/packages/intl
import 'package:azblob/azblob.dart';
import 'package:power_monitor/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:power_monitor/services/auth.dart';
import 'package:power_monitor/models/user.dart';

class ElectricityUsage {
  String location;
  static String odometer = 'init';
  static Timestamp timeStamp;
  static String userName;
  static Map<dynamic, String> historicReads;


  //ElectricityUsage({this.date, this.time, this.odometer});

  final CollectionReference consumptionCollection =
      Firestore.instance.collection('consumption');


  StreamBuilder<QuerySnapshot> stream = StreamBuilder(
    stream: Firestore.instance.collection('consumption').snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (!snapshot.hasData) {
        return new Text('Error: ${snapshot.error}');
      }
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return new Text('Loading...');
        default:
          String uid = "n1@gmail.com";
          var docList = snapshot.data.documents;
          var doc;
          String t = docList[0].documentID;

          for (int i = 0; i < docList.length; i++) {
            if (docList[i].documentID.compareTo(uid) == 1) {
              doc = docList[i];
              print('found!!!');
            } else {
              print('wanted doc NOT found!!!');
            }
          }
          String userName = doc.data['userName'] == null
              ? 'userName is returning null '
              : doc.data['userName'];
          print(userName);
          odometer = doc.data['odometer'] == null
              ? 'odometer is returning null '
              : doc.data['odometer'];
          print(odometer + 'kw');



          return new Text(odometer == null ? 'null!!' : odometer + ' kw');
      }
    },
  );

  Future<void> getUsage(String path) async {
    try {
      //make the request
      //var response = await https.delete(path, headers: {'Authorization': 'SharedAccessSignature sr=https%3a%2f%2fpowermonitor.servicebus.windows.net%2fpowermonitorqueue&sig=Cj4h7OQTfBBje5uxtQ9n5Bnzd66NbDXlkZHgwuA3AII%3d&se=1586360757&skn=RootManageSharedAccessKey'});
      //JsonUtf8Encoder(response.body);
      //print(response.body);

//      await DatabaseService(uid: usr.uid).consumptionCollection
//          .getDocuments().then();
      await Firestore.instance
          .collection('consumption')
          .getDocuments()
          .then((value) {
        odometer = (value.documents[0].data["elect_consumption"].toString());
        //time = value.documents[0].data["time"].toString();
      });
      //print(Firestore.instance.collection('consumption').document(usr.uid));

      //print(usr.uid);
      //print(odometer);
      //print(time);

      //print(ref.documentID);
      //odometer = response.body.toString();
    } catch (e) {
      print('caught error: $e');
      odometer = 'error reading';
    }
  }

  String get usage {
    getUsage(
        'https://powermonitor.servicebus.windows.net/powermonitorqueue/messages/head');
    return odometer;
  }
}
