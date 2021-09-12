import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker/model/dayRecord.dart';
import 'package:tracker/model/record.dart';
import 'package:tracker/trackerDatabase.dart';
import 'package:tracker/util/dateTimeUtil.dart';

class ChartTab extends StatefulWidget {
  const ChartTab({Key? key}) : super(key: key);

  @override
  _ChartTabState createState() => _ChartTabState();
}

class _ChartTabState extends State<ChartTab> {
  List<DayRecordModel> dayRecordModels = [];
  List<Record> records = [];
  bool initY = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.loadData();
  }

  loadData() async {
    this.records = await TrackerDatabase.instance.queryBetween(
        DateTime.now().subtract(Duration(days: 29)), DateTime.now());
    setState(() {
      this.dayRecordModels = DayRecordModel.groupRecordByDate(
          DateTime.now().subtract(Duration(days: 29)),
          DateTime.now(),
          this.records);
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 150));
    setState(() {
      this.initY = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            child: Text(
          '过去30天',
          style: TextStyle(color: Colors.white, fontSize: 25),
        )),
        Expanded(
            child: BarChart(
          BarChartData(
              alignment: BarChartAlignment.spaceEvenly,
              maxY: getMax() * 1.05,
              minY: 0,
              barTouchData: BarTouchData(
                enabled: false,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.transparent,
                  direction: TooltipDirection.top,
                  tooltipPadding: const EdgeInsets.all(0),
                  tooltipMargin: 0,
                  getTooltipItem: (
                    BarChartGroupData group,
                    int groupIndex,
                    BarChartRodData rod,
                    int rodIndex,
                  ) {
                    return BarTooltipItem(
                      rod.y.round().toString(),
                      TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 10
                      ),
                    );
                  },
                ),
              ),
              gridData: FlGridData(drawHorizontalLine: false),
              titlesData: FlTitlesData(
                  show: true,
                  rightTitles: SideTitles(showTitles: false),
                  topTitles: SideTitles(showTitles: false),
                  bottomTitles: SideTitles(
                      reservedSize: 45,
                      rotateAngle: 90,
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      // margin: 20,
                      getTitles: (double xValue) {
                        return DateTimeUtil.displayMonthAndDay(
                            DateTime.fromMillisecondsSinceEpoch(
                                xValue.toInt()));
                      }),
                  leftTitles: SideTitles(showTitles: false)),
              barGroups: this
                  .dayRecordModels
                  .map((e) => BarChartGroupData(
                          x: e.date.millisecondsSinceEpoch,
                          showingTooltipIndicators: [
                            0
                          ],
                          barRods: [
                            BarChartRodData(
                                y: (initY) ? 0 : e.getTotalRecords(),
                                colors: [
                                  Colors.lightBlueAccent,
                                  Colors.greenAccent
                                ])
                          ]))
                  .toList()),
          swapAnimationDuration: Duration(milliseconds: 300),
          swapAnimationCurve: Curves.linear,
        )),
      ],
    );
    // return Container();
  }

  double getMax() {
    double max = 1;
    this.dayRecordModels.forEach((element) {
      if (element.getTotalRecords() > max) {
        max = element.getTotalRecords();
      }
    });
    return max;
  }
}
