import 'package:flutter/material.dart';
import 'package:tracker/appStyling.dart';
import 'package:tracker/widget/chartTab.dart';
import 'package:tracker/widget/recordTab.dart';

void main() {
  runApp(MaterialApp(home: TrackerApp()));
}

class TrackerApp extends StatefulWidget {
  const TrackerApp({Key? key}) : super(key: key);

  @override
  _TrackerAppState createState() => _TrackerAppState();
}

class _TrackerAppState extends State<TrackerApp> {
  int currentTabIndex = 0;
  final tabs = [RecordTab(), ChartTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.themeColor,
        title: Text('Tracker'),
      ),
      body: tabs[this.currentTabIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColor.secondaryBackgroundColor,
          unselectedItemColor: AppColor.darkBackContentColor,
          selectedItemColor: AppColor.buttonColor,
          currentIndex: this.currentTabIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment_rounded), label: '记录'),
            BottomNavigationBarItem(
                icon: Icon(Icons.assessment_rounded), label: '图表'),
          ],
          onTap: (index) {
            setState(() {
              this.currentTabIndex = index;
            });
          },
        ),
      ),
    );
  }
}
