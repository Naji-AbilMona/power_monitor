import 'package:firebase_auth/firebase_auth.dart';
import 'package:power_monitor/models/user.dart';
import 'package:power_monitor/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String usage;
  String time;

  AuthService({this.usage, this.time});

  //create user object based on firebaseuser
  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }
  // auth change user stream
  Stream<User> get user{
    return _auth.onAuthStateChanged
      .map((FirebaseUser user)=> _userFromFirebaseUser(user));
      //.map(_userFromFirebaseUser);
  }

  FirebaseUser usr;
  //sign in anon
  Future signinAnon() async{
    try {
      AuthResult result = await _auth.signInAnonymously();
      usr = result.user;
      return _userFromFirebaseUser(usr);
    }catch(e){ print(e.toString());
        return null;
    }
  }
  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
      usr = result.user;
      await DatabaseService(uid: usr.uid).getUsage();
      usage = DatabaseService(uid: usr.uid).odometer;
      time = DatabaseService(uid: usr.uid).time;
      return _userFromFirebaseUser(usr);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password);
      usr = result.user;

      //create a new document for the user with uid
      await DatabaseService(uid: usr.uid).updateUserData(email, '0000h',0000);
      await DatabaseService(uid: usr.uid).getUsage();
      usage = DatabaseService(uid: usr.uid).odometer;
      time = DatabaseService(uid: usr.uid).time;

      return _userFromFirebaseUser(usr);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  FirebaseUser get getUsr{
    return usr;
  }

  //sign out
Future signOut() async {
    try{
      return await _auth.signOut();
    }catch(e){
        print(e.toString());
        return null;
    }
}

  String  get getUsage{
    return usage;
}

  String  get getTime{
    return time;
  }
}