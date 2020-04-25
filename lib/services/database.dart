import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //collection reference
  final CollectionReference consumptionCollection = Firestore.instance.collection('consumption');

  Future updateUserData(String userName, String location, Timestamp timeStamp, dynamic odometer,
      Map<dynamic, dynamic> historicReads) async {
    return await consumptionCollection.document(uid).setData({
      'userName': userName,
      'location': location,
      'timeStamp': timeStamp,
      'odometer': odometer,
      'historicReads': historicReads,
    });
  }
}
