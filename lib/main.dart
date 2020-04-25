import 'package:flutter/material.dart';
import 'package:power_monitor/models/user.dart';
import 'package:power_monitor/pages/screen_boxes/Wrapper.dart';
import 'package:power_monitor/services/auth.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
