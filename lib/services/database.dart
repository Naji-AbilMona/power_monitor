import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:power_monitor/services/auth.dart';

class DatabaseService {
  final String uid;
  String time;
  String odometer = 'no init';
  DatabaseService({this.uid, this.odometer, this.time});
  //collection reference
final CollectionReference consumptionCollection = Firestore.instance.collection('consumption');
Future updateUserData(String userName, String time, int elect_consumption) async {
  return await consumptionCollection.document(uid).setData({
  'userName':userName,
  'time':time,
  'elect_consumption':elect_consumption,
});
}


  Future getUsage() async{
    try {
      await Firestore.instance.collection('consumption').getDocuments().then((value){
        odometer = (value.documents[0].data["elect_consumption"].toString());
        time = value.documents[0].data["time"].toString();
      });
      print(uid);
      print('odometer: ' + odometer);
      print('time: ' + time);
    } catch (e) {
      print('caught error: $e');
      odometer = 'error reading';
    }
    }

  String get usage {
    //print(this.uid);
    getUsage ();
    return odometer;
  }

  String get timeData {
    //print(this.uid);
    getUsage ();
    return time;
  }



}