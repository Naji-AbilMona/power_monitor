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
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebaseUser(user));
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
      Timestamp timestamp = Timestamp.now();
      String location = 'Beirut'; //change later

      //create a new document for the user with uid
      await DatabaseService(uid: email.trim().toLowerCase())
          .updateUserData(email.trim().toLowerCase(), location, timestamp, '0000', {'timestamp':'read'},);

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
