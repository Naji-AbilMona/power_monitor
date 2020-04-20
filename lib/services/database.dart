import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:power_monitor/models/user.dart';
import 'package:power_monitor/services/auth.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //collection reference
  final CollectionReference consumptionCollection =
      Firestore.instance.collection('consumption');

  Future updateUserData(String userName, String location, Timestamp timeStamp,
      String odometer, Map<dynamic, String> historicReads) async {
    return await consumptionCollection.document(uid).setData({
      'userName': userName,
      'location': location,
      'timeStamp': timeStamp,
      'odometer': odometer,
      'historicReads': historicReads,
    });
  }
}
