import 'package:firebase_auth/firebase_auth.dart';
import 'package:power_monitor/models/user.dart';
import 'package:power_monitor/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String usage;
  String time;

  AuthService({this.usage, this.time});

  //create user object based on firebaseuser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid, email: user.email) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map((FirebaseUser user) => _userFromFirebaseUser(user));
    //.map(_userFromFirebaseUser);
  }

  FirebaseUser usr;

  //sign in anon
  Future signinAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      usr = result.user;
      return _userFromFirebaseUser(usr);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email.trim().toLowerCase(), password: password);
      usr = result.user;

      return _userFromFirebaseUser(usr);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email.trim().toLowerCase(), password: password);
      usr = result.user;
      String timestamp = new DateTime(DateTime.now().day, DateTime.now().month, DateTime.now().day,
              DateTime.now().hour, DateTime.now().minute)
          .toString();
      String location = 'Beirut'; //change later
      int currentYear = DateTime.now().year;
      int currentMonth = DateTime.now().month;
      int currentDay = DateTime.now().day;
      int currentHour = DateTime.now().hour;
      int currentMinute = DateTime.now().minute;

      int readDate = (currentYear * 100000000) +
          (currentMonth * 1000000) +
          (currentDay * 10000) +
          (currentHour * 100) +
          currentMinute;

      //create a new document for the user with uid
      await DatabaseService(uid: email.trim().toLowerCase()).updateUserData(
        email.trim().toLowerCase(),
        location,
        timestamp,
        '000000',
        {readDate.toString(): '000000'},
      );

      return _userFromFirebaseUser(usr);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
