import 'package:flutter/material.dart';
import 'package:tracker/appStyling.dart';
import 'package:tracker/model/record.dart';
import 'package:tracker/util/dateTimeUtil.dart';


class DateTimeRecordCard extends StatelessWidget {
  final Record record;
  final int index;
  final Function delete;

  DateTimeRecordCard(
      {required this.record, required this.index, required this.delete});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.secondaryBackgroundColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColor.outlineColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            // Expanded(
            //   flex: 1,
            //   child: Container(
            //     color: Colors.amberAccent,
            //     child: Text(
            //       this.index.toString()
            //     ),
            //   ),
            // ),
            Expanded(
              flex: 10,
              child: Text(
                DateTimeUtil.displayTime(this.record.dateTime),
                style: TextStyle(fontSize: 25,color: AppColor.darkBackContentColor),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.delete_forever,color:  AppColor.darkBackContentColor,),
                onPressed: () =>
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          AlertDialog(
                            title: const Text('删除记录'),
                            content: const Text(
                                '确定要删除这项纪录吗？'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'No'),
                                child: const Text('否'),
                              ),
                              TextButton(
                                onPressed: () {
                                  this.delete.call();
                                  Navigator.pop(context, 'Yes');
                                },
                                child: const Text('是'),
                              ),
                            ],
                          ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
