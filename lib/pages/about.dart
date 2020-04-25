import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text('About'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: Text(
          '\nThis application was developed as part of an AUB, CMPS 253 class project, under the supervision of Professor M. Bdeir, by:\n'
          'Christina Missirian\n'
          'Yehia Farhat\n'
          'Nazeer Daker\n'
          'Naji AbilMona\n',
          style: TextStyle(
            fontSize: 15,
            color: Colors.white70,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
