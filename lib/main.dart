import 'package:flutter/material.dart';
import 'package:power_monitor/pages/home.dart';
import 'package:power_monitor/pages/loading.dart';
import 'package:power_monitor/pages/about.dart';



void main() => runApp(MaterialApp(
        //initialRoute: '/',
        initialRoute: '/home',
        //initialRoute: '/about',
        routes: {
          '/': (context) => Loading(),
          '/home': (context) => Home(),
          '/about': (context) => About(),
        }));
