import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:power_monitor/models/user.dart';
import 'package:provider/provider.dart';

class ElectrisityBill extends StatefulWidget {
  @override
  _ElectrisityBillState createState() => _ElectrisityBillState();
}

class _ElectrisityBillState extends State<ElectrisityBill> {
  bool moreThan5kva = false;
  bool twoMonthBilling = false;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        title: Text('Electricity Bill'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/digital.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('consumption').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  print('Error: ${snapshot.error}');
                  return new Text('Loading...');
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading....');
                  default:
                    final user = Provider.of<User>(context);
                    String uid = user.email.trim();
                    var docList = snapshot.data.documents;
                    var doc;

                    for (int i = 0; i < docList.length; i++) {
                      if (docList[i].documentID.trim() == uid.trim()) doc = docList[i];
                    }

                    Map historicReads = doc.data['historicReads'];

                    int current = int.parse(doc.data['odometer'].toString());
                    int year;
                    int month;
                    int day;
                    int hour;
                    int minute;
                    int currentYear = DateTime.now().year;
                    int currentMonth = DateTime.now().month;
                    int firstReadHour = 25;
                    int firstReadMinute = 61;
                    int firstReadDayInMonth = 32;

                    historicReads.forEach((key, value) {
                      year = (int.parse(key.toString()) / 100000000).toInt();
                      month = ((int.parse(key.toString()) / 1000000) % 100).toInt();
                      day = ((int.parse(key.toString()) / 10000) % 100).toInt();
                      hour = ((int.parse(key.toString()) / 100) % 100).toInt();
                      minute = ((int.parse(key.toString())) % 100).toInt();

                      if ((year == currentYear) && (month == currentMonth)) {
                        if (day < firstReadDayInMonth) firstReadDayInMonth = day;
                      }
                    });
                    historicReads.forEach((key, value) {
                      year = (int.parse(key.toString()) / 100000000).toInt();
                      month = ((int.parse(key.toString()) / 1000000) % 100).toInt();
                      day = ((int.parse(key.toString()) / 10000) % 100).toInt();
                      hour = ((int.parse(key.toString()) / 100) % 100).toInt();
                      minute = ((int.parse(key.toString())) % 100).toInt();

                      if ((year == currentYear) &&
                          (month == currentMonth) &&
                          (day == firstReadDayInMonth)) {
                        if (hour <= firstReadHour) firstReadHour = hour;
                        if (hour == firstReadHour) {
                          if (minute <= firstReadMinute) firstReadMinute = minute;
                        }
                      }
                    });

                    int firstReadOfMonthDate = (currentYear * 100000000) +
                        (currentMonth * 1000000) +
                        (firstReadDayInMonth * 10000) +
                        (firstReadHour * 100) +
                        firstReadMinute;

                    int firstReadOfMonth =
                        (firstReadHour == 25 || firstReadMinute == 61 || firstReadDayInMonth == 32)
                            ? 0
                            : int.parse(historicReads[firstReadOfMonthDate.toString()].toString());

                    int monthToDateConsumption = current - firstReadOfMonth;

                    int bracketPrice(int kwh, int nMonths) {
                      if (nMonths == 1) {
                        if (kwh > 500) {
                          return (kwh - 500) * 200 +
                              (100 * 120) +
                              (100 * 80) +
                              (200 * 55) +
                              (100 * 35);
                        } else if (kwh > 400) {
                          return (kwh - 400) * 120 + (100 * 80) + (200 * 55) + (100 * 35);
                        } else if (kwh > 300) {
                          return (kwh - 300) * 80 + (200 * 55) + (100 * 35);
                        } else if (kwh > 100) {
                          return (kwh - 100) * 55 + (100 * 35);
                        } else
                          return kwh * 35;
                      } else if (nMonths == 2) {
                        if (kwh > 1000) {
                          return (kwh - 800) * 200 +
                              (200 * 120) +
                              (200 * 80) +
                              (400 * 55) +
                              (200 * 35);
                        } else if (kwh > 800) {
                          return (kwh - 800) * 120 + (200 * 80) + (400 * 55) + (200 * 35);
                        } else if (kwh > 600) {
                          return (kwh - 600) * 80 + (400 * 55) + (200 * 35);
                        } else if (kwh > 200) {
                          return (kwh - 200) * 55 + (200 * 35);
                        } else
                          return kwh * 35;
                      } else
                        return -1; // error
                    }
                    print('electrisity bill price m 1: ${bracketPrice(300, 1)}');
                    print('electrisity bill price m 2: ${bracketPrice(300, 2)}');

                    //Bill Items - http://www.edl.gov.lb/page.php?pid=39&lang=en#4
                    //SDL subscription contract PDF - http://www.edl.gov.lb/media/docs/Nizam%20ishtirak.pdf
                    //1. Monthly Tax = LBP 240/Amp, i.e. LBP12,000 for 5 k.v.a and LBP24,000 for 10 k.v.a
                    int monthlyTax;
                    if (twoMonthBilling) {
                      monthlyTax = (moreThan5kva ? 24000 : 12000) * 2;
                    } else
                      monthlyTax = moreThan5kva ? 24000 : 12000;

                    //2. Stamp Tax = LBP 1,000
                    int stampTax = 1000;

                    //3.Rehabilitation tax - LBP 5,000 for 5k.v.a and LBP10,000 for more than 10 k.v.a
                    int rehabilitationTax;
                    if(twoMonthBilling){
                      rehabilitationTax = (moreThan5kva ? 10000 * 2 : 5000 * 2);
                    }else{
                      rehabilitationTax = (moreThan5kva ? 10000 : 5000);
                    }


                    //4. Consumption price - based on the bracket calculation
                    int consumptionEST = twoMonthBilling
                        ? ((monthToDateConsumption * (60 / DateTime.now().day)).toInt())
                        : ((monthToDateConsumption * (30 / DateTime.now().day)).toInt());

                    int consumptionPriceMTD = twoMonthBilling
                        ? bracketPrice(monthToDateConsumption, 2)
                        : bracketPrice(monthToDateConsumption, 1);

                    int consumptionPriceEST = twoMonthBilling
                        ? bracketPrice(consumptionEST, 2)
                        : bracketPrice(consumptionEST, 1);

                    //5.TVA - 11% of the total of the above items 1, 2, 3, 4
                    int tvaMTD =
                        ((monthlyTax + stampTax + rehabilitationTax + consumptionPriceMTD) * 0.11)
                            .toInt();
                    int tvaEST =
                        ((monthlyTax + stampTax + rehabilitationTax + consumptionPriceEST) * 0.11)
                            .toInt();

                    //Total Bill
                    int totalBillMTD =
                        monthlyTax + stampTax + rehabilitationTax + consumptionPriceMTD + tvaMTD;
                    int totalBillEST =
                        monthlyTax + stampTax + rehabilitationTax + consumptionPriceEST + tvaEST;

                    return Column(
                      children: <Widget>[
                        Image(
                          image: AssetImage('assets/edl.png'),
                          height: MediaQuery.of(context).size.height / 6.5,
                          width: MediaQuery.of(context).size.width / 5.5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Subscription of more than 5 k.v.a',
                              style: TextStyle(
                                fontSize: h/45,
                                color: Colors.lightGreenAccent,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Switch(
                              value: moreThan5kva,
                              onChanged: (value) {
                                setState(() {
                                  moreThan5kva = value;
                                  print('More than 5 k.v.a: ' + moreThan5kva.toString());
                                });
                              },
                              activeTrackColor: Colors.lightGreenAccent,
                              activeColor: Colors.green,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Two-month billing',
                              style: TextStyle(
                                fontSize: h/45,
                                color: Colors.lightGreenAccent,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Switch(
                              value: twoMonthBilling,
                              onChanged: (value) {
                                setState(() {
                                  twoMonthBilling = value;
                                  print('Two months billing: ' + twoMonthBilling.toString());
                                });
                              },
                              activeTrackColor: Colors.lightGreenAccent,
                              activeColor: Colors.green,
                            ),
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height / 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  'Month-to-Date\nConsumption\n',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: h/35,
                                    color: Color(0xffffa500),
                                  ),
                                ),
                                SizedBox(height: h/86),
                                Text(
                                    firstReadHour == 25 || firstReadMinute == 61
                                        ? 'no reads this month'
                                        : monthToDateConsumption.toString() + ' kwh',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: h/25,
                                      wordSpacing: 2,
                                      color: Colors.grey[200],
                                    )),
                              ],
                            ),
                            //SizedBox(width: MediaQuery.of(context).size.width / 3),
                            Column(
                              children: <Widget>[
                                Text(
                                  twoMonthBilling
                                      ? 'Two-Month\nConsumption\nEstimation'
                                      : 'Full Month\nConsumption\nEstimation',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: h/35,
                                    color: Color(0xffffa500),
                                  ),
                                ),
                                SizedBox(height: h/86),
                                Text(
                                    firstReadHour == 25 || firstReadMinute == 61
                                        ? 'no reads this month'
                                        : consumptionEST.toString() + ' kwh',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: h/25,
                                      wordSpacing: 2,
                                      color: Colors.grey[200],
                                    )),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height / 16),

                        Container(
                          color: Colors.white38,
                          child: DataTable(
                            dataRowHeight: h/23,
                            columns: [
                              DataColumn(label: Text('Item\nLBP\'s', style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold),)),
                              DataColumn(
                                  label: Text('Amount\nMTD',
                                      style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center)),
                              DataColumn(
                                  label: Text('Amount\nEST',
                                      style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center)),
                            ],
                            rows: [
                              DataRow(cells: [
                                DataCell(Text('Consumption', style: TextStyle(color: Colors.grey[900]),)),
                                DataCell(Text(consumptionPriceMTD.toString(),
                                    style: TextStyle(color: Colors.grey[900]),
                                    textAlign: TextAlign.right)),
                                DataCell(Text(consumptionPriceEST.toString(),
                                    style: TextStyle(color: Colors.grey[900]),
                                    textAlign: TextAlign.right)),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Monthly Taxes', style: TextStyle(color: Colors.grey[900]),)),
                                DataCell(Text((monthlyTax + stampTax + rehabilitationTax).toString(),
                                    style: TextStyle(color: Colors.grey[900]),
                                    textAlign: TextAlign.right)),
                                DataCell(Text((monthlyTax + stampTax + rehabilitationTax).toString(),
                                    style: TextStyle(color: Colors.grey[900]),
                                    textAlign: TextAlign.right)),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('VAT @ 11%', style: TextStyle(color: Colors.grey[900]),)),
                                DataCell(Text(tvaMTD.toString(),
                                    style: TextStyle(color: Colors.grey[900]),
                                    textAlign: TextAlign.right)),
                                DataCell(Text(tvaEST.toString(),
                                    style: TextStyle(color: Colors.grey[900]),
                                    textAlign: TextAlign.right)),
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Total', style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold),)),
                                DataCell(Text(totalBillMTD.toString(),
                                    style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right)),
                                DataCell(Text(totalBillEST.toString(),
                                    style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right)),
                              ]),
                            ],
                          ),
                        ),
                      ],
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
