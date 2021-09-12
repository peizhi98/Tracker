import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tracker/appStyling.dart';
import 'package:tracker/model/record.dart';
import 'package:tracker/trackerDatabase.dart';
import 'package:tracker/util/dateTimeUtil.dart';
import 'package:tracker/widget/dateTimeRecordCard.dart';

class RecordTab extends StatefulWidget {
  const RecordTab({Key? key}) : super(key: key);

  @override
  _RecordTabState createState() => _RecordTabState();
}

class _RecordTabState extends State<RecordTab> {
  late List<Record> records = [];
  DateTime selectedDate = DateTime.now();
  late AudioPlayer player;
  String localAudioFilePath = 'button_click.mp3';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    player = AudioPlayer();

    loadRecord();
  }

  loadRecord() async {
    List<Record> latestRecords =
        await TrackerDatabase.instance.queryDate(selectedDate);
    setState(() {
      records = latestRecords;
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryBackgroundColor,
      body: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                this.selectedDate = DateTime.now();
              });
              this.loadRecord();
            },
            child: SizedBox(
              height: 90,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.symmetric(
                        horizontal: BorderSide(color: AppColor.outlineColor, width: 1))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: AppColor.buttonColor,
                        child: IconButton(
                          iconSize: 50,
                          icon: Icon(Icons.arrow_left_rounded),
                          onPressed: () {
                            setState(() {
                              this.selectedDate =
                                  this.selectedDate.subtract(Duration(days: 1));
                            });
                            this.loadRecord();
                          },
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Container(
                          color: AppColor.secondaryBackgroundColor,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    child: Text(
                                  getDateOrTodayTomorrowYesterday(selectedDate),
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: AppColor.darkBackContentColor),
                                )),
                                Container(
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(color: Colors.blueAccent)
                                  // ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 1.0, horizontal: 10.0),
                                  // color: AppColor.themeColor,
                                  decoration: BoxDecoration(
                                      color: AppColor.themeColor,
                                      border: Border.all(
                                        color: AppColor.outlineColor,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Text(
                                      '总次数: ' + this.records.length.toString(),
                                      style: TextStyle(
                                          fontSize: 25,
                                          color:
                                              AppColor.darkBackContentColor)),
                                )
                              ],
                            ),
                          ),
                        )),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: AppColor.buttonColor,
                        child: IconButton(
                          iconSize: 50,
                          icon: Icon(Icons.arrow_right_rounded),
                          onPressed: () {
                            setState(() {
                              this.selectedDate =
                                  this.selectedDate.add(Duration(days: 1));
                            });
                            this.loadRecord();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: Column(
                      children: records
                          .map((r) => DateTimeRecordCard(
                                record: r,
                                index: records.indexOf(r),
                                delete: () {
                                  TrackerDatabase.instance.delete(r.id!);
                                  this.loadRecord();
                                },
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.buttonColor,
        onPressed: () async {
          player.setAsset('assets/button_click.mp3');
          player.play();
          DateTime now = DateTime.now();
          this.selectedDate = now;
          int i = await TrackerDatabase.instance.insert(now);
          this.loadRecord();
        },
        child: const Icon(
          Icons.alarm_add,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  String getDateOrTodayTomorrowYesterday(DateTime date) {
    DateTime today = DateTime.now();
    if (this.selectedDate.compareDate(today) == 0)
      return '今天';
    else if (this.selectedDate.compareDate(today.add(Duration(days: 1))) == 0)
      return '明天';
    else if (this.selectedDate.compareDate(today.subtract(Duration(days: 1))) ==
        0) return '昨天';
    return DateTimeUtil.displayDate(date);
  }
}
