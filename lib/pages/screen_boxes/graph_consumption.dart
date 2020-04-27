import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//import 'package:syncfusion_flutter_charts/charts.dart'; //charts package. https://pub.dev/packages/syncfusion_flutter_charts#-readme-tab-
import 'package:fl_chart/fl_chart.dart'; //charts package 2. https://pub.dev/packages/fl_chart#-readme-tab-
import 'package:intl/intl.dart';
import 'package:power_monitor/models/user.dart';
import 'package:provider/provider.dart';

class GraphConsumption extends StatefulWidget {
  @override
  _GraphConsumptionState createState() => _GraphConsumptionState();
}

class _GraphConsumptionState extends State<GraphConsumption> {
  List<Color> gradientColors = [
    const Color(0xffffa500),
    const Color(0xffffa500),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(18),
                ),
                color: const Color(0x00000000)),
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
              child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('consumption').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      print('Error: ${snapshot.error}');
                      return new Text('\nLoading...');
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return new Text('\nLoading....');
                      default:
                        final user = Provider.of<User>(context);
                        String uid = user.email.trim();
                        var docList = snapshot.data.documents;
                        var doc;

                        for (int i = 0; i < docList.length; i++) {
                          if (docList[i].documentID.trim() == uid.trim()) doc = docList[i];
                        }

                        Map historicReads = doc.data['historicReads'];

                        List firstLastdates(int currentYear, currentMonth, currentDay) {
                          int maxHour = -1;
                          int minHour = 25;
                          int maxMinute = -1;
                          int minMinute = 61;

                          int year;
                          int month;
                          int day;
                          int hour;
                          int minute;

                          int cDay = (currentMonth == 2) && (currentDay > 28) ? 28 : currentDay;

                          historicReads.forEach((key, value) {
                            year = (int.parse(key.toString()) / 100000000).toInt();
                            month = ((int.parse(key.toString()) / 1000000) % 100).toInt();
                            day = ((int.parse(key.toString()) / 10000) % 100).toInt();
                            hour = ((int.parse(key.toString()) / 100) % 100).toInt();
                            minute = ((int.parse(key.toString())) % 100).toInt();
                            if (year == currentYear && month == currentMonth && day == cDay) {
                              if (hour < minHour) minHour = hour;
                              if (hour > maxHour) maxHour = hour;
                            }
                          });
                          historicReads.forEach((key, value) {
                            year = (int.parse(key.toString()) / 100000000).toInt();
                            month = ((int.parse(key.toString()) / 1000000) % 100).toInt();
                            day = ((int.parse(key.toString()) / 10000) % 100).toInt();
                            hour = ((int.parse(key.toString()) / 100) % 100).toInt();
                            minute = ((int.parse(key.toString())) % 100).toInt();
                            if (year == currentYear && month == currentMonth && day == cDay) {
                              if (hour == minHour && minute < minMinute) minMinute = minute;
                              if (hour == maxHour && minute > maxMinute) maxMinute = minute;
                            }
                          });
                          int firstReadOfDayDate = (currentYear * 100000000) +
                              (currentMonth * 1000000) +
                              (cDay * 10000) +
                              (minHour * 100) +
                              minMinute;
                          int lastReadOfDayDate = (currentYear * 100000000) +
                              (currentMonth * 1000000) +
                              (cDay * 10000) +
                              (maxHour * 100) +
                              maxMinute;
                          return [firstReadOfDayDate, lastReadOfDayDate];
                        }

                        List<FlSpot> graphData = [
//                          FlSpot(0, 3),
                        ];

                        double i = 0;
                        double scale = 10;

                        //month minus 2 data: day 1, day 10, day 20, day 30 (if Feb, day 28)
                        int m2Year = DateTime(
                                DateTime.now().year, (DateTime.now().month - 2), DateTime.now().day)
                            .year;
                        int m2Month = DateTime(
                                DateTime.now().year, (DateTime.now().month - 2), DateTime.now().day)
                            .month;
                        String keyM2_d1_first =
                            firstLastdates(m2Year, m2Month, 1)[0].toString().trim();
                        int m2_1_first = historicReads[keyM2_d1_first] == null
                            ? null
                            : int.parse(historicReads[keyM2_d1_first].toString());
                        String keyM2_d1_last =
                            firstLastdates(m2Year, m2Month, 1)[1].toString().trim();
                        int m2_1_last = historicReads[keyM2_d1_last] == null
                            ? null
                            : int.parse(historicReads[keyM2_d1_last].toString());
                        graphData.add(FlSpot(
                            i,
                            (m2_1_last == null || m2_1_first == null
                                ? 0
                                : (m2_1_last - m2_1_first).toDouble() / scale)));
                        i++;
                        String keyM2_d10_first =
                            firstLastdates(m2Year, m2Month, 10)[0].toString().trim();
                        int m2_10_first = historicReads[keyM2_d10_first] == null
                            ? null
                            : int.parse(historicReads[keyM2_d10_first].toString());
                        String keyM2_d10_last =
                            firstLastdates(m2Year, m2Month, 10)[1].toString().trim();
                        int m2_10_last = historicReads[keyM2_d10_last] == null
                            ? null
                            : int.parse(historicReads[keyM2_d10_last].toString());
                        graphData.add(FlSpot(
                            i,
                            (m2_10_last == null || m2_10_first == null
                                ? 0
                                : (m2_10_last - m2_10_first).toDouble() / scale)));
                        i++;

                        String keyM2_d20_first =
                            firstLastdates(m2Year, m2Month, 20)[0].toString().trim();
                        int m2_20_first = historicReads[keyM2_d20_first] == null
                            ? null
                            : int.parse(historicReads[keyM2_d20_first].toString());
                        String keyM2_d20_last =
                            firstLastdates(m2Year, m2Month, 20)[1].toString().trim();
                        int m2_20_last = historicReads[keyM2_d20_last] == null
                            ? null
                            : int.parse(historicReads[keyM2_d20_last].toString());
                        graphData.add(FlSpot(
                            i,
                            (m2_20_last == null || m2_20_first == null
                                ? 0
                                : (m2_20_last - m2_20_first).toDouble() / scale)));
                        i++;

                        String keyM2_d30_first =
                            firstLastdates(m2Year, m2Month, 30)[0].toString().trim();
                        int m2_30_first = historicReads[keyM2_d30_first] == null
                            ? null
                            : int.parse(historicReads[keyM2_d30_first].toString());
                        String keyM2_d30_last =
                            firstLastdates(m2Year, m2Month, 30)[1].toString().trim();
                        int m2_30_last = historicReads[keyM2_d30_last] == null
                            ? null
                            : int.parse(historicReads[keyM2_d30_last].toString());
                        graphData.add(FlSpot(
                            i,
                            (m2_30_last == null || m2_30_first == null
                                ? 0
                                : (m2_30_last - m2_30_first).toDouble() / scale)));
                        i++;

                        //month minus 1 data: day 1, day 10, day 20, day 30 (if Feb, day 28)
                        int m1Year = DateTime(
                                DateTime.now().year, (DateTime.now().month - 1), DateTime.now().day)
                            .year;
                        int m1Month = DateTime(
                                DateTime.now().year, (DateTime.now().month - 1), DateTime.now().day)
                            .month;
                        String keyM1_d1_first =
                            firstLastdates(m1Year, m1Month, 1)[0].toString().trim();
                        int m1_1_first = historicReads[keyM1_d1_first] == null
                            ? null
                            : int.parse(historicReads[keyM1_d1_first].toString());
                        String keyM1_d1_last =
                            firstLastdates(m1Year, m1Month, 1)[1].toString().trim();

                        int m1_1_last = historicReads[keyM1_d1_last] == null
                            ? null
                            : int.parse(historicReads[keyM1_d1_last].toString());
                        graphData.add(FlSpot(
                            i,
                            (m1_1_last == null || m1_1_first == null
                                ? 0
                                : (m1_1_last - m1_1_first).toDouble() / scale)));
                        i++;

                        String keyM1_d10_first =
                            firstLastdates(m1Year, m1Month, 10)[0].toString().trim();
                        int m1_10_first = historicReads[keyM1_d10_first] == null
                            ? null
                            : int.parse(historicReads[keyM1_d10_first].toString());
                        String keyM1_d10_last =
                            firstLastdates(m1Year, m1Month, 10)[1].toString().trim();
                        int m1_10_last = historicReads[keyM1_d10_last] == null
                            ? null
                            : int.parse(historicReads[keyM1_d10_last].toString());
                        graphData.add(FlSpot(
                            i,
                            (m1_10_last == null || m1_10_first == null
                                ? 0
                                : (m1_10_last - m1_10_first).toDouble() / scale)));
                        i++;

                        String keyM1_d20_first =
                            firstLastdates(m1Year, m1Month, 20)[0].toString().trim();
                        int m1_20_first = historicReads[keyM1_d20_first] == null
                            ? null
                            : int.parse(historicReads[keyM1_d20_first].toString());
                        String keyM1_d20_last =
                            firstLastdates(m1Year, m1Month, 20)[1].toString().trim();
                        int m1_20_last = historicReads[keyM1_d20_last] == null
                            ? null
                            : int.parse(historicReads[keyM1_d20_last].toString());
                        graphData.add(FlSpot(
                            i,
                            (m1_20_last == null || m1_20_first == null
                                ? 0
                                : (m1_20_last - m1_20_first).toDouble() / scale)));
                        i++;

                        String keyM1_d30_first =
                            firstLastdates(m1Year, m1Month, 30)[0].toString().trim();
                        int m1_30_first = historicReads[keyM1_d30_first] == null
                            ? null
                            : int.parse(historicReads[keyM1_d30_first].toString());
                        String keyM1_d30_last =
                            firstLastdates(m1Year, m1Month, 30)[1].toString().trim();
                        int m1_30_last = historicReads[keyM1_d30_last] == null
                            ? null
                            : int.parse(historicReads[keyM1_d30_last].toString());
                        graphData.add(FlSpot(
                            i,
                            (m1_30_last == null || m1_30_first == null
                                ? 0
                                : (m1_30_last - m1_30_first).toDouble() / scale)));
                        i++;

                        //current month data: day 1, day 10, day 20, day 30 (if Feb, day 28)
                        int currentYear = DateTime.now().year;
                        int currentMonth = DateTime.now().month;
                        String current_d1_first =
                            firstLastdates(currentYear, currentMonth, 1)[0].toString().trim();
                        int current_1_first = historicReads[current_d1_first] == null
                            ? null
                            : int.parse(historicReads[current_d1_first].toString());
                        String current_d1_last =
                            firstLastdates(currentYear, currentMonth, 1)[1].toString().trim();

                        int current_1_last = historicReads[current_d1_last] == null
                            ? null
                            : int.parse(historicReads[current_d1_last].toString());
                        graphData.add(FlSpot(
                            i,
                            (current_1_last == null || current_1_first == null
                                ? 0
                                : (current_1_last - current_1_first).toDouble() / scale)));
                        i++;

                        String current_d10_first =
                            firstLastdates(currentYear, currentMonth, 10)[0].toString().trim();
                        int current_10_first = historicReads[current_d10_first] == null
                            ? null
                            : int.parse(historicReads[current_d10_first].toString());
                        String current_d10_last =
                            firstLastdates(currentYear, currentMonth, 10)[1].toString().trim();
                        int current_10_last = historicReads[current_d10_last] == null
                            ? null
                            : int.parse(historicReads[current_d10_last].toString());
                        if (current_10_first != null || current_10_last != null) {
                          graphData.add(FlSpot(
                              i,
                              (current_10_last == null || current_10_first == null
                                  ? null
                                  : (current_10_last - current_10_first).toDouble() / scale)));
                        }
                        i++;

                        String current_d20_first =
                            firstLastdates(currentYear, currentMonth, 20)[0].toString().trim();
                        int current_20_first = historicReads[current_d20_first] == null
                            ? null
                            : int.parse(historicReads[current_d20_first].toString());
                        String current_d20_last =
                            firstLastdates(currentYear, currentMonth, 20)[1].toString().trim();
                        int current_20_last = historicReads[current_d20_last] == null
                            ? null
                            : int.parse(historicReads[current_d20_last].toString());
                        if (current_20_first != null || current_20_last != null) {
                          graphData.add(FlSpot(
                              i,
                              (current_20_last == null || current_20_first == null
                                  ? null
                                  : (current_20_last - current_20_first).toDouble() / scale)));
                        }
                        i++;

                        String current_d30_first =
                            firstLastdates(currentYear, currentMonth, 30)[0].toString().trim();
                        int current_30_first = historicReads[current_d30_first] == null
                            ? null
                            : int.parse(historicReads[current_d30_first].toString());
                        String current_d30_last =
                            firstLastdates(currentYear, currentMonth, 30)[1].toString().trim();
                        int current_30_last = historicReads[current_d30_last] == null
                            ? null
                            : int.parse(historicReads[current_d30_last].toString());
                        if (current_30_first != null || current_30_last != null) {
                          graphData.add(FlSpot(
                              i,
                              (current_30_last == null || current_30_first == null
                                  ? null
                                  : (current_30_last - current_30_first).toDouble() / scale)));
                        }
                        i++;

                        return LineChart(
                          showAvg ? avgData() : mainData(graphData),
                        );
                    }
                  }),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 28,
          child: FlatButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'kWh/day',
              style: TextStyle(
                  fontSize: 11, color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData mainData(var data) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 20,
          textStyle:
              TextStyle(color: const Color(0xff18ffff), fontWeight: FontWeight.bold, fontSize: 14),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return new DateFormat('MMM-y').format(
                    DateTime(DateTime.now().year, (DateTime.now().month - 2), DateTime.now().day));
              case 5:
                return new DateFormat('MMM-y').format(
                    DateTime(DateTime.now().year, (DateTime.now().month - 1), DateTime.now().day));
              case 8:
                return new DateFormat('MMM-y').format(DateTime.now());
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: const Color(0xff18ffff),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10 ';
              case 3:
                return '30';
              case 5:
                return '50';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData:
          FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: data,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff18ffff),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff18ffff),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle:
              TextStyle(color: const Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: const Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData:
          FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2),
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2),
          ],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(show: true, colors: [
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2).withOpacity(0.1),
            ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2).withOpacity(0.1),
          ]),
        ),
      ],
    );
  }
}
