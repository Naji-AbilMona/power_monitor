import 'package:power_monitor/pages/home.dart';
import 'package:power_monitor/pages/about.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:power_monitor/pages/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:power_monitor/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    //return home or authentication widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
